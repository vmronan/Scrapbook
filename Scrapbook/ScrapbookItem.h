//
//  ScrapbookItem.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScrapbookItem : NSObject

@property int rowId;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* description;

- (id)initWithURL:(NSString*)url title:(NSString*)title description:(NSString*)description rowId:(int)rowId;

@end
