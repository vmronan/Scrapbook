//
//  LocalPhotoSaver.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/24/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalPhotoSaver : NSObject

+ (NSString *)saveOrigImage:(UIImage *)image;
+ (NSString *)saveEditedImage:(UIImage *)image fromOrigPath:(NSString *)origPath;

@end
