//
//  PhotoSearchViewController.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrVC.h"
#import "InstagramVC.h"

@interface PhotoSearchVC : UITabBarController

@property (strong, nonatomic) InstagramVC *instaViewController;
@property (strong, nonatomic) FlickrVC *flickrViewController;

@property (strong, nonatomic) ScrapbookModel *model;

- (id)initWithModel:(ScrapbookModel*)model;

@end
