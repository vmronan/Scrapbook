//
//  CropRegionView.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/24/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "CropRegionCenterView.h"

@implementation CropRegionCenterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(resize)];
        [self addGestureRecognizer:self.pinchRecognizer];
        
//        [self setBackgroundColor:[UIColor redColor]];
//        [self setAlpha:0.5];
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // standard dragging relative movement calculations
    if (self.parentView != nil && [touches count] == 1) {
        // calculate the delta x
        CGFloat deltaX = [[touches anyObject] locationInView:self.superview].x - [[touches anyObject] previousLocationInView:self.superview].x;
        // calculate the delta y
        CGFloat deltaY = [[touches anyObject] locationInView:self.superview].y - [[touches anyObject] previousLocationInView:self.superview].y;
        
        // make the new positions
        CGFloat newX = self.frame.origin.x + deltaX;
        CGFloat newY = self.frame.origin.y + deltaY;
        
        // move the view
        self.frame = CGRectMake(newX, newY, self.frame.size.width, self.frame.size.height);
        
        // check to see if we've moved the view beyond it's appropriate bounds
        [self checkBounds];
    }
}

// adjust the view to be within the bounds of the image as it appears in the imageView
- (void)checkBounds
{
    CGFloat newX = self.frame.origin.x;
    CGFloat newY = self.frame.origin.y;
    
    // the maximum edges cannot be precomputed without the width and height of this view, which could change
    // if a pinch gesture is implemented
    CGFloat maxX = self.imageBoundsInView.origin.x + self.imageBoundsInView.size.width - self.frame.size.width;
    CGFloat maxY = self.imageBoundsInView.origin.y + self.imageBoundsInView.size.height - self.frame.size.height;
    
    
    // check bounds
    if (newX < self.imageBoundsInView.origin.x) {
        newX = self.imageBoundsInView.origin.x;
    }
    if (newX > maxX) {
        newX = maxX;
    }
    
    if (newY < self.imageBoundsInView.origin.y) {
        newY = self.imageBoundsInView.origin.y;
    }
    if (newY > maxY) {
        newY = maxY;
    }
    
    // move to the bounded location
    self.frame = CGRectMake((int)newX, (int)newY, (int)self.frame.size.width, (int)self.frame.size.height);
    [self.superview performSelector:@selector(resizeCropRegions:) withObject:self];
    
}

- (void)resize
{
    CGFloat new_size;
    
    if (self.pinchRecognizer.scale < 1.0) {
        new_size = self.frame.size.width + (self.pinchRecognizer.velocity / self.pinchRecognizer.scale);
    } else {
        
        new_size = self.frame.size.width + self.pinchRecognizer.velocity;
    }
    
    if(new_size > self.imageBoundsInView.size.height) {
        new_size = self.imageBoundsInView.size.height;
    }
    
    CGFloat delta = (self.frame.size.width - new_size)/2;
    self.frame = CGRectMake(self.frame.origin.x + delta, self.frame.origin.y + delta, new_size, new_size);
    
    [self checkBounds];
}

/*
 * here we need to convert from the cropper's in-image-view-bounds
 * to the corresponding bounds in the original image
 */
- (CGRect)cropBounds
{
    /*
     * calculate the in-image x and y coordinates
     * these can be calculated given the ratio: inImageX / imageWidth == inImageViewX / imageViewImageWidth
     * therefore inImageX = inImageViewX / imageViewImageWidth * imageWidth
     * the inImageViewX can be computed to be the cropper's x coordinate in
     * the image view minus the image's x coordinate in the image view
     */
    CGFloat inImageX = ((self.frame.origin.x - self.imageBoundsInView.origin.x) / self.imageBoundsInView.size.width) * self.parentView.image.size.width;
    CGFloat inImageY = ((self.frame.origin.y - self.imageBoundsInView.origin.y) / self.imageBoundsInView.size.height) * self.parentView.image.size.height;
    
    // a similar ratio gives us the image size... fortunately we are using a square. Things get complex fast without a square
    CGFloat inImageSize = (self.frame.size.width / self.imageBoundsInView.size.width) * self.parentView.image.size.width;
    
    // return the computed bounds NOTE: if you wish to return the bounds for a CIImage crop, the y bound must be:
    // original_image_height - inImageY - inImageSize because the CIImage cooridnate system is flipped in the y
    // dimension
    return CGRectMake(inImageX, inImageY, inImageSize, inImageSize);
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
