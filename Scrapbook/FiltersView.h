//
//  FiltersView.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/27/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FiltersView : UIView

@property int height;
@property int width;
@property (strong, nonatomic) UIImage *image;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;

@end
