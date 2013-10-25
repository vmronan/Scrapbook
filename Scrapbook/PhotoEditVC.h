//
//  PhotoCropVC.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/24/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrapbookModel.h"
#import "ScrapbookItem.h"
#import "CropRegionView.h"
#import "ScrapbookItemEditVC.h"

@interface PhotoEditVC : UIViewController

@property (strong, nonatomic) ScrapbookModel *model;
@property (strong, nonatomic) ScrapbookItem *item;
@property (strong, nonatomic) UIImageView *imageView;
@property CropRegionView *cropRegionView;

@property (strong, nonatomic) UIButton *vignetteButton;
@property (strong, nonatomic) UIButton *chromeButton;
@property (strong, nonatomic) UIButton *posterizeButton;

- (void)doneButtonPressed;
- (void)showFilterButtons;
- (void)showOrigPhoto;
- (UIImageView *)setImageViewForImage:(UIImage *)image withMaxWidth:(int)maxWidth maxHeight:(int)maxHeight;
- (void)showCropRegion;

- (void)applyVignetteFilter;
- (void)applyChromeFilter;
- (void)applyPosterizeFilter;
- (void)applyFilter:(NSString*)filterName;

@end
