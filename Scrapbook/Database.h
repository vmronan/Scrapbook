//
//  Database.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/3/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrapbookItem.h"
#import <sqlite3.h>

@interface Database : NSObject

+ (void)createEditableCopyOfDatabaseIfNeeded;
+ (void)initDatabase;
+ (NSMutableArray *)fetchAllItems;
+ (void)saveScrapbookItemWithPath:(NSString *)path title:(NSString*)title description:(NSString*)description;
+ (void)updateScrapbookItemWithPath:(NSString *)path title:(NSString *)title description:(NSString *)description atRow:(int)rowId;
+ (void)deleteScrapbookItem:(int)rowid;
+ (void)cleanUpDatabaseForQuit;

@end
