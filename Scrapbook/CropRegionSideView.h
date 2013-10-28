//
//  CropRegionSideView.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropRegionSideView : UIView

@property (strong, nonatomic) UIImageView *parentView;

- (void)toggleCropRegion;
- (void)resizeWithx:(int)x y:(int)y width:(int)width height:(int)height;

@end
