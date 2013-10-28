//
//  CropRegionSideView.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "CropRegionSideView.h"

@implementation CropRegionSideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAlpha:0.5];
    }
    return self;
}

- (void)resizeWithx:(int)x y:(int)y width:(int)width height:(int)height
{
    [self setFrame:CGRectMake(x, y, width, height)];
}

- (void)toggleCropRegion
{
    if([self isHidden]) {
        self.hidden = NO;
    }
    else {
        self.hidden = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
