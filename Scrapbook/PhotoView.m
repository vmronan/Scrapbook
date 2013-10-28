//
//  PhotoCropVC.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/24/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "PhotoView.h"

@implementation PhotoView

- (id)initWithFrame:(CGRect)frame photo:(UIImage *)photo
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        [self showPhoto:photo];
        [self showCropRegion];
        [self toggleCropRegion];
    }
    return self;
}

- (UIImage *)getCroppedImage
{
    if(self.cropRegionView.hidden == NO) {
        // Get temporary UIImage of pixels in crop region from the original image
        CGImageRef croppedCGImage = CGImageCreateWithImageInRect(self.image.CGImage, [self.cropRegionView cropBounds]);
        UIImage *temp = [UIImage imageWithCGImage:croppedCGImage];
        
        // Draw UIImage with the new dimensions in the image context
        UIGraphicsBeginImageContext(CGSizeMake(320.0, 320.0));
        [temp drawInRect:CGRectMake(0, 0, 320, 320)];
        UIImage *croppedUIImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // End the graphics context and release the CGImage
        UIGraphicsEndImageContext();
        CGImageRelease(croppedCGImage);
        
        return croppedUIImage;
    }
    else {
        return self.image;
    }
}

- (void)showPhoto:(UIImage *)photo
{
    [self setContentMode:UIViewContentModeScaleAspectFit];
    [self setImage:photo];
    
    // Pass touches in the imageview to the crop region
    [self setUserInteractionEnabled:YES];
}

- (UIImageView *)setImageViewForImage:(UIImage *)image withMaxWidth:(int)maxWidth maxHeight:(int)maxHeight atHeight:(int)y
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width, height;    // to be defined
    
    if(imageHeight/imageWidth > 1.0) {
        // Image is tall (or square)
        height = maxHeight;
        width = height / imageHeight * imageWidth;
    }
    else {
        // Image is wide
        width = maxWidth;
        height = width / imageWidth * imageHeight;
    }
    
    return [[UIImageView alloc] initWithFrame:CGRectMake((maxWidth-width)/2, y, width, height)];
}

- (void)showCropRegion
{
    // Create and show center cropping box
    self.cropRegionView = [[CropRegionCenterView alloc] initWithFrame:CGRectMake(self.bounds.size.height/7, self.bounds.size.height/7, self.bounds.size.height*5/7, self.bounds.size.height*5/7)];
    self.cropRegionView.imageBoundsInView = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.cropRegionView.parentView = self;
    [self addSubview:self.cropRegionView];
    
    // Create and show side cropping boxes
    int photoWidth = self.bounds.size.width;
    int photoHeight = self.bounds.size.height;
    int originX = self.cropRegionView.frame.origin.x;
    int originY = self.cropRegionView.frame.origin.y;
    int width = self.cropRegionView.frame.size.width;
    int height = self.cropRegionView.frame.size.height;
    self.leftCropView = [[CropRegionSideView alloc] initWithFrame:CGRectMake(0, 0, originX, photoHeight)];
    self.rightCropView = [[CropRegionSideView alloc] initWithFrame:CGRectMake(originX+width, 0, photoWidth-originX-width, photoHeight)];
    self.topCropView = [[CropRegionSideView alloc] initWithFrame:CGRectMake(originX, 0, width, originY)];
    self.bottomCropView = [[CropRegionSideView alloc] initWithFrame:CGRectMake(originX, originY+height, width, photoHeight-originY-height+1)];

    [self addSubview:self.leftCropView];
    [self addSubview:self.rightCropView];
    [self addSubview:self.topCropView];
    [self addSubview:self.bottomCropView];
}

- (void)resizeCropRegions:(CropRegionCenterView *)sender
{
    [self.leftCropView resizeWithx:0 y:0 width:sender.frame.origin.x height:self.bounds.size.height+1];
    [self.rightCropView resizeWithx:sender.frame.origin.x+sender.frame.size.width y:0 width:self.frame.size.width-sender.frame.origin.x-sender.frame.size.width+1 height:self.bounds.size.height+1];
    [self.topCropView resizeWithx:sender.frame.origin.x y:0 width:sender.frame.size.width height:sender.frame.origin.y];
    [self.bottomCropView resizeWithx:sender.frame.origin.x y:sender.frame.origin.y+sender.frame.size.height width:sender.frame.size.width height:self.frame.size.height-sender.frame.origin.y-sender.frame.size.height+1];
}

- (void)toggleCropRegion
{
    [self.cropRegionView toggleCropRegion];
    [self.leftCropView toggleCropRegion];
    [self.rightCropView toggleCropRegion];
    [self.topCropView toggleCropRegion];
    [self.bottomCropView toggleCropRegion];
}

@end
