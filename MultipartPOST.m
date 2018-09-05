//
//  MultipartPOST.m
//  multipart-test-app
//
//  Created by Assad Karim on 9/4/18.
//  Copyright © 2018 FuturePerfect. All rights reserved.
//

#import "MultipartPOST.h"

@implementation MultipartPOST

+ (void)postMultiPartFormData:(NSDictionary *)paramsDictionary files:(NSArray<NSDictionary*> *)files {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // create url
    NSString *url = @"ENTER_URL_HERE";
    [request setURL:[NSURL URLWithString:url]];
    // cache policy
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    // cookies
    [request setHTTPShouldHandleCookies:NO];
    // timeout
    [request setTimeoutInterval:60];
    // http method type
    [request setHTTPMethod:@"POST"];
    // auth token
    [request setValue:@"AUTH_TOKEN_IF_ANY" forHTTPHeaderField:@"x-access-token"];
    
    // define request boundary
    NSString *boundary = [MultipartPOST generateBoundaryString];
    // set content type
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // initialize body
    NSMutableData *body = [NSMutableData data];
    
    // add params
    [paramsDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", value] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add files to be uploaded
    for (NSDictionary *file in files) {
        // file data as NSData
        NSData *fileData = file[@"data"];
        // other attributes
        NSString *filename = file[@"name"];
        NSString *mimeType = file[@"mimeType"];
        NSString *fieldName = file[@"fieldName"];
        // append data in body
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:fileData];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    // calculate body length and set http header field
    NSString *postLength = [NSString stringWithFormat:@"%d", (unsigned int)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // create session
    NSURLSession *session = [NSURLSession sharedSession];
    // create task
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", [@"postMultiPartFormData error dataTaskWithRequest: " stringByAppendingString:error.description]);
            return;
        }
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", [@"dataTaskWithRequest Result: " stringByAppendingString:result]);
        NSDictionary *responseDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"Response Dictionary: %@", responseDictionary.description);
    }];
    [task resume];
}

+ (NSString *)generateBoundaryString {
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

@end
