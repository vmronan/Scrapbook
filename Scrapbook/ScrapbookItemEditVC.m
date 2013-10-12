//
//  PhotoEditViewController.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "ScrapbookItemEditVC.h"
#import "ScrapbookVC.h"

@interface ScrapbookItemEditVC ()

@end

@implementation ScrapbookItemEditVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setTitle:@"Edit photo"];
        
        self.item = [[ScrapbookItem alloc] init];
        
        // Make save button in navigation bar
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
        [self.navigationItem setRightBarButtonItem:saveButton animated:NO];
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)saveButtonPressed
{
    self.item.title = self.titleField.text;
    self.item.description = self.descriptionField.text;
    [self.model saveItem:self.item];
    
    ScrapbookVC *scrapbookVC = [[ScrapbookVC alloc] init];
    scrapbookVC.model = self.model;
    [scrapbookVC update];
    [self.navigationController pushViewController:scrapbookVC animated:YES];
}

- (void)editItem:(ScrapbookItem*)item
{
    self.item = item;
    [self showPhotoAtURL:item.url];
}

- (void)showPhotoAtURL:(NSString*)url
{
    // Show image at full width of screen
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    int screenWidth = self.view.bounds.size.width;
    float imageRatio = image.size.height / image.size.width;
    float scaledImageHeight = screenWidth * imageRatio;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 174, screenWidth, scaledImageHeight)];
    [imageView setImage:image];
    [self.view addSubview:imageView];
}

- (void)editPhotoAtURL:(NSString*)url
{
    [self showPhotoAtURL:url];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(self.item.rowId != -1) {
        [self.titleField setText:self.item.title];
        [self.descriptionField setText:self.item.description];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
