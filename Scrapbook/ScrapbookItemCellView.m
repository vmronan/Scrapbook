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

- (id)initWithItem:(ScrapbookItem *)item
{
    self = [super init];
    if (self) {
        // Read image from documents folder and make imageview
        NSData *pngData = [NSData dataWithContentsOfFile:item.path];
        UIImage *image = [UIImage imageWithData:pngData];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        UITextView *titleView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 340, 30)];
        [titleView setText:item.title];
        [titleView setTextColor:[UIColor blackColor]];
        
        [self addSubview:imageView];
        [self addSubview:titleView];
        [self setTag:imageView.bounds.size.height+30];
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
