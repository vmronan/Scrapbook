//
//  ScrapbookItem.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalPhotoSaver.h"

@interface ScrapbookItem : NSObject

@property int rowId;
@property (strong, nonatomic) NSString* origPath;
@property (strong, nonatomic) NSString* currentPath;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* description;

- (id)initWithImage:(UIImage*)image title:(NSString*)title description:(NSString*)description rowId:(int)rowId;
- (id)initWithOrigPath:(NSString *)origPath currentPath:(NSString* )currentPath title:(NSString *)title description:(NSString *)description rowId:(int)rowId;

@end
