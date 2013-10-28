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
    }
    return self;
}

- (UIImage *)getCroppedImage
{
    // Get temporary UIImage of pixels in crop region from the original image
    CGImageRef croppedCGImage = CGImageCreateWithImageInRect(self.imageView.image.CGImage, [self.cropRegionView cropBounds]);
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
    NSLog(@"creating crop region. ");
    // Create and show cropping box
    self.cropRegionView = [[CropRegionView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-50, self.bounds.size.height/2-50, 100, 100)];
    self.cropRegionView.parentView = self;
    self.cropRegionView.imageBoundsInView = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:self.cropRegionView];
}

- (void)toggleCropRegion
{
    if([self.cropRegionView isHidden]) {
        self.cropRegionView.hidden = NO;
    }
    else {
        self.cropRegionView.hidden = YES;
    }
}

@end
