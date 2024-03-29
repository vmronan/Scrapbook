//
//  CropRegionView.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/24/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropRegionCenterView : UIView

@property (strong, nonatomic) UIImageView *parentView;
@property CGRect imageBoundsInView;
@property UIPinchGestureRecognizer *pinchRecognizer;

- (void)checkBounds;
- (CGRect)cropBounds;

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)toggleCropRegion;

@end
