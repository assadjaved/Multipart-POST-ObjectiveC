//
//  MultipartPOST.h
//  multipart-test-app
//
//  Created by Assad Karim on 9/4/18.
//  Copyright © 2018 FuturePerfect. All rights reserved.
//

// Parameters:

// 1. paramsDictionary
// example: @{ name: "the_name", age: "the_age", and: "so_on_and_so_forth" }

// 2. files: accepts an array of NSDictionary type objects
// example:

/*  UIImage *image = [UIImage imageNamed:@"image.jpeg"];
 NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
 NSDictionary *file = @{
 @"data": imageData,
 @"name": @"myfile.jpeg",
 @"mimeType:": @"image/jpeg",
 @"fieldName": @"file"
 };
 NSArray *files = @[file];
 */

#import <Foundation/Foundation.h>

@interface MultipartPOST : NSObject

+ (void)postMultiPartFormData:(NSDictionary *)paramsDictionary files:(NSArray<NSDictionary*> *)files;

@end
