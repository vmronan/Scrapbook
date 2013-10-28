//
//  CropRegionView.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/24/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropRegionView : UIView

@property (strong, nonatomic) UIImageView *parentView;
@property CGRect imageBoundsInView;
@property UIPinchGestureRecognizer *pinchRecognizer;

@property UIView *center;
@property CGRect left;
@property CGRect right;
@property CGRect top;
@property CGRect bottom;

- (void)checkBounds;
- (CGRect)cropBounds;

- (void)showCropRegion;
- (void)toggleCropRegion;

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end
