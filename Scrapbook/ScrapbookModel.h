//
//  ScrapbookModel.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrapbookItem.h"

@interface ScrapbookModel : NSObject

@property (strong, nonatomic) NSMutableArray *items;

- (void)updateItems;
- (NSMutableArray*)allItems;
- (ScrapbookItem*)itemAtIndex:(int)index;
- (int)numItems;

- (void)saveItem:(ScrapbookItem*)item;
- (void)addItemAtURL:(NSString*)url withTitle:(NSString*)title description:(NSString*)description;
- (void)deleteItemAtIndex:(int)index;


@end
