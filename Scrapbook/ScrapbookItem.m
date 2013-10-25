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
        NSString* origPath = [LocalPhotoSaver saveOrigImage:image];   // *** here it will save the image to a path, then save the path
        self.origPath = origPath;
        self.currentPath = origPath;
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

@end
