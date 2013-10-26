//
//  PhotoEditViewController.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrapbookModel.h"
#import "PhotoEditVC.h"

@interface ScrapbookItemEditVC : UIViewController

@property (strong, nonatomic) ScrapbookModel *model;
@property (strong, nonatomic) ScrapbookItem *item;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) UITextField *descriptionField;
@property (strong, nonatomic) UIButton *cropButton;
@property (strong, nonatomic) UIButton *revertButton;

- (void)saveItem;
- (void)cropButtonPressed;
- (void)editItem:(ScrapbookItem*)item;
- (void)editPhotoAtPath:(NSString*)path;
- (void)showPhotoAtPath:(NSString*)path;

@end
