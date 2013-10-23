//
//  PhotoDetailViewController.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "ScrapbookModel.h"
#import "ScrapbookItemEditVC.h"

@interface ScrapbookItemDetailVC : UIViewController

@property (strong, nonatomic) ScrapbookModel *model;
@property (strong, nonatomic) ScrapbookItem *item;
@property int itemIndex;

- (void)editButtonPressed;
- (void)showItemAtIndex:(int)index;

@end
