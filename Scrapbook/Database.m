//
//  Database.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/3/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "Database.h"
#import <sqlite3.h>

@implementation Database

static sqlite3 *db;

static sqlite3_stmt *createItemsTable;
static sqlite3_stmt *fetchItem;
static sqlite3_stmt *fetchItems;
static sqlite3_stmt *insertItem;
static sqlite3_stmt *updateItem;
static sqlite3_stmt *deleteItem;

+ (void)createEditableCopyOfDatabaseIfNeeded {
    BOOL success;
    
    // Look for an existing scrapbook items database
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentDirectory stringByAppendingPathComponent:@"items.sql"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    
    // If failed to find one, copy the empty scrapbook items database into the location
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"items.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"FAILED to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

+ (void)initDatabase {
    // Create the statement strings
    const char *createItemsTableString = "CREATE TABLE IF NOT EXISTS items (rowid INTEGER PRIMARY KEY AUTOINCREMENT, origPath TEXT, currentPath TEXT, title TEXT, description TEXT)";
    const char *fetchItemString = "SELECT * FROM items WHERE rowid=?";
    const char *fetchItemsString = "SELECT * FROM items";
    const char *insertItemString = "INSERT INTO items (origPath, currentPath, title, description) VALUES (?, ?, ?, ?)";
    const char *updateItemString = "UPDATE items SET origPath=?, currentPath=?, title=?, description=? WHERE rowid=?";
    const char *deleteItemString = "DELETE FROM items WHERE rowid=?";
    
    // Create the path to the database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"items.sql"];
    
    // Open the database connection
    if (sqlite3_open([path UTF8String], &db)) {
        NSLog(@"ERROR opening the db");
    }
    
    int success;
    
    // Init create table statement
    if (sqlite3_prepare_v2(db, createItemsTableString, -1, &createItemsTable, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare create items table statement");
    }
    
    // Execute the table creation statement
    success = sqlite3_step(createItemsTable);
    sqlite3_reset(createItemsTable);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to create items table");
    }
    
    // Init single item retreival statement
    if (sqlite3_prepare_v2(db, fetchItemString, -1, &fetchItem, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare single item fetching statement");
    }
    
    // Init all items retrieval statement
    if (sqlite3_prepare_v2(db, fetchItemsString, -1, &fetchItems, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare all items fetching statement");
    }
    
    // Init insertion statement
    if (sqlite3_prepare_v2(db, insertItemString, -1, &insertItem, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare item inserting statement");
    }
    
    // Init update statement
    if (sqlite3_prepare_v2(db, updateItemString, -1, &updateItem, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare item update statement");
    }
    
    // Init deletion statement
    if (sqlite3_prepare_v2(db, deleteItemString, -1, &deleteItem, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare item deleting statement");
    }
}

+ (ScrapbookItem *)fetchItemWithId:(int)rowId
{
    // Bind the row id, step the statement, reset the statement, return item if no error
    sqlite3_bind_int(fetchItem, 1, rowId);
    int success = sqlite3_step(fetchItem);
    sqlite3_reset(deleteItem);
    if(success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to fetch scrapbook item");
        return nil;
    }
    
    // query columns from fetch statement
    char *origPathChars = (char *) sqlite3_column_text(fetchItems, 1);
    char *currentPathChars = (char *) sqlite3_column_text(fetchItems, 2);
    char *titleChars = (char *) sqlite3_column_text(fetchItems, 3);
    char *descriptionChars = (char *) sqlite3_column_text(fetchItems, 4);
    // convert to NSStrings
    NSString *tempOrigPath = [NSString stringWithUTF8String:origPathChars];
    NSString *tempCurrentPath = [NSString stringWithUTF8String:currentPathChars];
    NSString *tempTitle = [NSString stringWithUTF8String:titleChars];
    NSString *tempDescription = [NSString stringWithUTF8String:descriptionChars];
    
    //create ScrapbookItem object, notice the query for the row id
    return [[ScrapbookItem alloc] initWithOrigPath:tempOrigPath currentPath:tempCurrentPath title:tempTitle description:tempDescription rowId:sqlite3_column_int(fetchItems, 0)];
}

+ (NSMutableArray *)fetchAllItems
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    
    while (sqlite3_step(fetchItems) == SQLITE_ROW) {
        
        // query columns from fetch statement
        char *origPathChars = (char *) sqlite3_column_text(fetchItems, 1);
        char *currentPathChars = (char *) sqlite3_column_text(fetchItems, 2);
        char *titleChars = (char *) sqlite3_column_text(fetchItems, 3);
        char *descriptionChars = (char *) sqlite3_column_text(fetchItems, 4);
        // convert to NSStrings
        NSString *tempOrigPath = [NSString stringWithUTF8String:origPathChars];
        NSString *tempCurrentPath = [NSString stringWithUTF8String:currentPathChars];
        NSString *tempTitle = [NSString stringWithUTF8String:titleChars];
        NSString *tempDescription = [NSString stringWithUTF8String:descriptionChars];
        
        //create ScrapbookItem object, notice the query for the row id
        ScrapbookItem *item = [[ScrapbookItem alloc] initWithOrigPath:tempOrigPath currentPath:tempCurrentPath title:tempTitle description:tempDescription rowId:sqlite3_column_int(fetchItems, 0)];
        [items addObject:item];
    }
    
    sqlite3_reset(fetchItems);
    return items;
}

+ (void)saveNewScrapbookItemWithOrigPath:(NSString *)origPath currentPath:(NSString *)currentPath title:(NSString*)title description:(NSString*)description
{
    // Bind data to the statement
    sqlite3_bind_text(insertItem, 1, [origPath UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertItem, 2, [currentPath UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertItem, 3, [title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertItem, 4, [description UTF8String], -1, SQLITE_TRANSIENT);
    int success = sqlite3_step(insertItem);
    sqlite3_reset(insertItem);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to insert scrapbook item");
    }
}

+ (void)updateScrapbookItemWithOrigPath:(NSString *)origPath currentPath:(NSString *)currentPath title:(NSString *)title description:(NSString *)description atRow:(int)rowId
{
    NSLog(@"updating title to %@, description to %@", title, description);
    // Bind data to the statement
    sqlite3_bind_text(updateItem, 1, [origPath UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateItem, 2, [currentPath UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateItem, 3, [title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateItem, 4, [description UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(updateItem, 5, rowId);
    
    // Step and reset statement, check for error
    int success = sqlite3_step(updateItem);
    sqlite3_reset(updateItem);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to update scrapbook item");
    }
}

+ (void)deleteScrapbookItem:(int)rowid
{
    // Bind the row id, step the statement, reset the statement, check for error
    sqlite3_bind_int(deleteItem, 1, rowid);
    int success = sqlite3_step(deleteItem);
    sqlite3_reset(deleteItem);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to delete scrapbook item");
    }
}

+ (void)cleanUpDatabaseForQuit
{
    // Finalize frees the compiled statements, close closes the database connection
    sqlite3_finalize(fetchItems);
    sqlite3_finalize(insertItem);
    sqlite3_finalize(deleteItem);
    sqlite3_finalize(createItemsTable);
    sqlite3_close(db);
}

@end
