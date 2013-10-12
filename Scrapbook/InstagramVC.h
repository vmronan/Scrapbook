//
//  InstagramVC.h
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/29/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoTagSearcher.h"
#import "ScrapbookItemEditVC.h"

@interface InstagramVC : UITableViewController

@property (strong, nonatomic) UITextField *queryField;
@property (strong, nonatomic) IBOutlet UITableView *photosTable;
@property (strong, nonatomic) PhotoTagSearcher *tagSearcher;
@property (strong, nonatomic) UIActivityIndicatorView *loadingSpinner;

@property (strong, nonatomic) ScrapbookModel *model;
@property (strong, nonatomic) NSMutableArray *photoURLs;
@property (strong, nonatomic) NSMutableArray *photoHeights;

+ (UIColor*)instagramBlue;

- (void)didPressSearch;
- (void)handleInstagramResponse:(NSMutableDictionary *)response;
@end
