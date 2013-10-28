//
//  PhotoCropVC.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/24/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropRegionCenterView.h"
#import "CropRegionSideView.h"

@interface PhotoView : UIImageView

//@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) CropRegionCenterView *cropRegionView;
@property (strong, nonatomic) CropRegionSideView *leftCropView;
@property (strong, nonatomic) CropRegionSideView *rightCropView;
@property (strong, nonatomic) CropRegionSideView *topCropView;
@property (strong, nonatomic) CropRegionSideView *bottomCropView;

- (id)initWithFrame:(CGRect)frame photo:(UIImage *)photo;
- (void)showPhoto:(UIImage *)photo;
- (void)showCropRegion;
- (UIImage *)getCroppedImage;
- (UIImageView *)setImageViewForImage:(UIImage *)image withMaxWidth:(int)maxWidth maxHeight:(int)maxHeight atHeight:(int)y;
- (void)toggleCropRegion;

@end
