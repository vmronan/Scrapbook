//
//  PhotoCropVC.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/24/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropRegion.h"

@interface PhotoView : UIImageView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) CropRegion *cropRegion;
//@property CropRegionView *cropRegionView;

- (id)initWithFrame:(CGRect)frame photo:(UIImage *)photo;
- (void)showPhoto:(UIImage *)photo;
- (void)showCropRegion;
- (UIImageView *)setImageViewForImage:(UIImage *)image withMaxWidth:(int)maxWidth maxHeight:(int)maxHeight atHeight:(int)y;
- (void)toggleCropRegion;

@end
