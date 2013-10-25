//
//  PhotoCropVC.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/24/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropRegionView.h"

@interface PhotoCropVC : UIViewController

@property (strong, nonatomic) UIImageView *imageView;
@property CropRegionView *cropRegionView;

- (void)doneButtonPressed;
- (void)showPhotoAtPath:(NSString *)path;
- (UIImageView *)setImageViewForImage:(UIImage *)image withMaxWidth:(int)maxWidth maxHeight:(int)maxHeight;
- (void)showCropRegion;

@end
