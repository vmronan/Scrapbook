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
@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionField;

- (IBAction)cropButtonPressed:(id)sender;
- (void)editItem:(ScrapbookItem*)item;
- (void)editPhotoAtPath:(NSString*)path;
- (void)showPhotoAtPath:(NSString*)path;

@end
