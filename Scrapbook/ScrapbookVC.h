//
//  ScrapbookViewController.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrapbookItemCellView.h"
#import "PhotoSearchVC.h"
#import "ScrapbookItemDetailVC.h"

@interface ScrapbookVC : UITableViewController

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) ScrapbookModel *model;
@property (strong, nonatomic) PhotoSearchVC *photoSearchVC;
@property (strong, nonatomic) ScrapbookItemDetailVC *scrapbookItemDetailVC;

- (void)addButtonPressed;
- (void)update;

@end

