//
//  CropRegionVC.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropRegion : UIView

@property (strong, nonatomic) UIImageView *parentView;
@property UIPinchGestureRecognizer *pinchRecognizer;

@property (strong, nonatomic) UIView *centerBox;
@property (strong, nonatomic) UIView *leftBox;
@property (strong, nonatomic) UIView *rightBox;
@property (strong, nonatomic) UIView *topBox;
@property (strong, nonatomic) UIView *bottomBox;


- (void)toggleCropRegion;

@end
