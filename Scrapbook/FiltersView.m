//
//  FiltersView.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/27/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "FiltersView.h"

@implementation FiltersView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.width = 80;
        self.height = frame.size.height-20;
        
        [self shrinkImage:image];
        [self showFilters];
    }
    return self;
}

- (void)shrinkImage:(UIImage *)image
{
    // Shrink image to specified height
    CGSize destinationSize = CGSizeMake(self.width, self.height);
    UIGraphicsBeginImageContext(destinationSize);
    [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *shrunkImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = shrunkImage;
}

- (void)showFilters
{
    NSArray *filters = [[NSArray alloc] initWithObjects:[CIFilter filterWithName:@"CIVignette"],
                        [CIFilter filterWithName:@"CIPhotoEffectChrome"],
                        [CIFilter filterWithName:@"CIColorPosterize"], nil];
    NSArray *filterNames = [[NSArray alloc] initWithObjects:@"Original", @"Vignette", @"Chrome", @"Posterize", nil];
    
    // Show original image
    
    for(int i = 0; i < [filterNames count]; i++) {
        UIImage *filteredImage = self.image;
        if(i != 0) {
            filteredImage = [self applyFilter:[filters objectAtIndex:i-1]];
        }
        
        UIImageView *filteredImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width*i, 0, self.width, self.height)];
        [filteredImageView setImage:filteredImage];
        
        UILabel *filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width*i, self.height, self.width, 20)];
        [filterLabel setText:[filterNames objectAtIndex:i]];
        
        [filterLabel setFont:[UIFont systemFontOfSize:12]];
        [filterLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:filteredImageView];
        [self addSubview:filterLabel];
    }
}

- (UIImage *)applyFilter:(CIFilter *)filter
{
    if (self.image != nil) {
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CIImage *original = [CIImage imageWithCGImage:self.image.CGImage];
        CIFilter *fadeFilter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
        [fadeFilter setValue:original forKey:@"inputImage"];
        CIImage *newImage = [fadeFilter valueForKey:@"outputImage"];

        [filter setValue:newImage forKey:@"inputImage"];
        CIImage *newNewImage = [filter valueForKey:@"outputImage"];
        
        CGImageRef cgimage = [context createCGImage:newNewImage fromRect:[newNewImage extent]];
        UIImage *newUIImage = [UIImage imageWithCGImage:cgimage];
        CGImageRelease(cgimage);

        return newUIImage;
    }
    return nil;
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
