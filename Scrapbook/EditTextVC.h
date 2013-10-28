//
//  ScrapbookItemEditTextVC.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrapbookModel.h"

@interface EditTextVC : UIViewController

@property (strong, nonatomic) ScrapbookModel *model;
@property (strong, nonatomic) ScrapbookItem *item;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) UITextField *descriptionField;

- (void)setupWithImage:(UIImage *)image;

@end
