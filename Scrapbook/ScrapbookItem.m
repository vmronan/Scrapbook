//
//  ScrapbookItem.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "ScrapbookItem.h"

@implementation ScrapbookItem

- (id)initWithURL:(NSString*)url title:(NSString*)title description:(NSString *)description rowId:(int)rowId
{
    self = [super init];
    if(self) {
        self.rowId = rowId;
        self.url = url;
        self.title = title;
        self.description = description;
    }
    return self;
}

@end
