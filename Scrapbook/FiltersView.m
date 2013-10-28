//
//  FiltersView.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/27/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "FiltersView.h"

@implementation FiltersView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image target:(id)target filters:(NSArray *)filters filterNames:(NSArray *)filterNames
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.target = target;
        self.filters = filters;
        self.filterNames = filterNames;
        
        self.width = 80;
        self.height = frame.size.height-16;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 80*[filterNames count], frame.size.height)];
        [self addSubview:self.scrollView];
        
        [self shrinkImage:image];
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
    for(int i = 0; i < [self.filterNames count]; i++) {
        // Filter image
        UIImage *filteredImage = self.image;
        if(i != 0) {
            filteredImage = [self applyFilter:[self.filters objectAtIndex:i-1]];     // i-1 to ignore the Normal label
        }
        
        // Put filtered image in imageview and add tap recognizer
        UIImageView *filteredImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width*i+1, 0, self.width-2, self.height)];
        [filteredImageView setImage:filteredImage];
        filteredImageView.tag = i-1;
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.target action:@selector(applyFilter:)];
        [filteredImageView addGestureRecognizer:tap];
        filteredImageView.userInteractionEnabled = YES;
        
        UILabel *filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width*i, self.height, self.width, 16)];
        [filterLabel setText:[self.filterNames objectAtIndex:i]];
        [filterLabel setFont:[UIFont systemFontOfSize:11]];
        [filterLabel setBackgroundColor:[UIColor whiteColor]];
        [filterLabel setTextAlignment:NSTextAlignmentCenter];
        [self.scrollView addSubview:filteredImageView];
        [self.scrollView addSubview:filterLabel];
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
