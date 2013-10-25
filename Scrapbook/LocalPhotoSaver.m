//
//  LocalPhotoSaver.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/24/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "LocalPhotoSaver.h"

@implementation LocalPhotoSaver

// Following functions based on http://stackoverflow.com/questions/6821517/save-an-image-to-application-documents-folder-from-uiview-on-ios
+ (NSString *)saveOrigImage:(UIImage*)image
{
    NSData *pngData = UIImagePNGRepresentation(image);
    NSString *filePath = [self documentsPathForFileName:[NSString stringWithFormat:@"%d.png", arc4random() % 9999999]];     // Name file a random 8-digit number with png extension
    [pngData writeToFile:filePath atomically:YES];    // Write the file
    return filePath;
}

+ (NSString *)saveEditedImage:(UIImage *)image fromOrigPath:(NSString *)origPath
{
    NSString *origFilename = [[origPath lastPathComponent] stringByDeletingPathExtension];
    
    NSData *pngData = UIImagePNGRepresentation(image);
    NSString *filePath = [self documentsPathForFileName:[NSString stringWithFormat:@"%@_edit.png", origFilename]];     // Name file a random 8-digit number with png extension
    [pngData writeToFile:filePath atomically:YES];    // Write the file
    return filePath;
}

+ (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];          // Get the documents directory
    return [documentsPath stringByAppendingPathComponent:name];     // Add the file name
}


@end
