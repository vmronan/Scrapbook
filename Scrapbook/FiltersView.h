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
@property (strong, nonatomic) UIScrollView *scrollView;
@property id target;

@property (strong, nonatomic) NSArray *filters;
@property (strong, nonatomic) NSArray *filterNames;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image target:(id)target filters:(NSArray *)filters filterNames:(NSArray *)filterNames;
- (void)showFilters;

@end
