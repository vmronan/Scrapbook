//
//  PhotoEditViewController.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrapbookModel.h"
#import "PhotoView.h"
#import "FiltersView.h"

@interface ScrapbookItemEditVC : UIViewController

@property (strong, nonatomic) ScrapbookModel *model;
@property (strong, nonatomic) ScrapbookItem *item;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) FiltersView *filtersView;
@property (strong, nonatomic) PhotoView *photoView;
@property (strong, nonatomic) UIImage *origImage;

@property (strong, nonatomic) NSArray *filters;
@property (strong, nonatomic) NSArray *filterNames;

- (void)applyFilter:(UITapGestureRecognizer*)sender;
- (void)saveItem;
- (void)showView;
- (CGRect)getPhotoFrameForImage:(UIImage *)image withMaxWidth:(int)maxWidth maxHeight:(int)maxHeight atHeight:(int)y;

@end
