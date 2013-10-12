//
//  ScrapbookModel.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "ScrapbookModel.h"
#import "Database.h"

@implementation ScrapbookModel

- (id)init
{
	self = [super init];
	if (self) {
        [self updateItems];
    }
	return self;
}

- (void)updateItems
{
    self.items = [Database fetchAllItems];
}

- (NSMutableArray*)allItems
{
    return [Database fetchAllItems];
}

- (void)saveItem:(ScrapbookItem*)item
{
    // Add item if it's new, otherwise update existing item
    if(item.rowId == -1) {
        [Database saveScrapbookItemWithURL:item.url title:item.title description:item.description];
    }
    else {
        [Database updateScrapbookItemWithURL:item.url title:item.title description:item.description atRow:item.rowId];
    }
    
    [self updateItems];
}

- (void)addItemAtURL:(NSString*)url withTitle:(NSString*)title description:(NSString*)description;
{
    [Database saveScrapbookItemWithURL:url title:title description:description];
    [self updateItems];
}

- (void)deleteItemAtIndex:(int)index
{
    [self updateItems];
    ScrapbookItem *item = [self.items objectAtIndex:index];
    [Database deleteScrapbookItem:item.rowId];
    [self.items removeObjectAtIndex:index];
}

- (ScrapbookItem*)itemAtIndex:(int)index
{
    return [self.items objectAtIndex:index];
}

- (int)numItems
{
    return [self.items count];
}

@end
