//
//  ScrapbookItemCellView.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/13/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "ScrapbookItemCellView.h"

@implementation ScrapbookItemCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithItem:(ScrapbookItem *)item screenWidth:(int)screenWidth
{
    self = [super init];
    if (self) {
        // Read image from documents folder
        NSData *pngData = [NSData dataWithContentsOfFile:item.path];
        UIImage *image = [UIImage imageWithData:pngData];
        
        // Show image at full width of screen
        float divider = 0.4;
        float imageRatio = image.size.height / image.size.width;
        float scaledImageHeight = screenWidth * imageRatio;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth*divider, scaledImageHeight*divider)];
        [imageView setImage:image];
        
        int titleHeight = 26;
        UITextView *titleView = [[UITextView alloc] initWithFrame:CGRectMake(screenWidth*divider, 0, screenWidth-(screenWidth*divider), titleHeight)];
        [titleView setText:item.title];
        titleView.font = [UIFont systemFontOfSize:30];
        [titleView sizeToFit];
        [titleView setTextColor:[UIColor blackColor]];
        
        UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(screenWidth*divider, titleView.bounds.size.height, screenWidth-(screenWidth*divider), scaledImageHeight-titleHeight)];
        [descriptionView setText:item.description];
        [descriptionView setTextColor:[UIColor grayColor]];
        
        [self addSubview:imageView];
        [self addSubview:titleView];
        [self addSubview:descriptionView];
        [self setTag:scaledImageHeight*divider];
        
    }
    return self;
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
