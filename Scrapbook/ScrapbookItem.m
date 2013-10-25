//
//  ScrapbookItem.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "ScrapbookItem.h"

@implementation ScrapbookItem

// Called by Flickr and Instagram view controllers to create an object from the image selected.
// Impossible for image to be edited at this point.
- (id)initWithImage:(UIImage*)image title:(NSString*)title description:(NSString *)description rowId:(int)rowId
{
    self = [super init];
    if(self) {
        self.rowId = rowId;
        NSString* origPath = [self saveImage:image];   // *** here it will save the image to a path, then save the path
        self.origPath = origPath;
        self.currentPath = origPath;
        NSLog(@"created image at path %@", self.origPath);
        self.title = title;
        self.description = description;
    }
    return self;
}

// Called by the database to create a new object from data in the database
- (id)initWithOrigPath:(NSString *)origPath currentPath:(NSString* )currentPath title:(NSString *)title description:(NSString *)description rowId:(int)rowId
{
    self = [super init];
    if(self) {
        self.rowId = rowId;
        self.origPath = origPath;
        self.currentPath = currentPath;
        self.title = title;
        self.description = description;
    }
    return self;
}


// Following 2 functions based on http://stackoverflow.com/questions/6821517/save-an-image-to-application-documents-folder-from-uiview-on-ios
- (NSString *)saveImage:(UIImage*)image
{
    NSData *pngData = UIImagePNGRepresentation(image);
    NSString *filePath = [self documentsPathForFileName:[NSString stringWithFormat:@"%d.png", arc4random() % 9999999]];     // Name file a random 8-digit number with png extension
    [pngData writeToFile:filePath atomically:YES];    // Write the file
    NSLog(@"saving image at path: %@", filePath);
    return filePath;
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];          // Get the documents directory
    return [documentsPath stringByAppendingPathComponent:name];     // Add the file name
}

@end
