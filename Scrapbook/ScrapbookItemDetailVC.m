//
//  PhotoDetailViewController.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "ScrapbookItemDetailVC.h"

@interface ScrapbookItemDetailVC ()

@end

@implementation ScrapbookItemDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"Photo Details"];
        
        // Make edit button in navigation bar
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed)];
        [self.navigationItem setRightBarButtonItem:editButton animated:NO];
    }
    return self;
}

- (void)editButtonPressed
{
    // Create the next view controller.
    ScrapbookItemEditVC *scrapbookItemCreateVC = [[ScrapbookItemEditVC alloc] initWithNibName:@"ScrapbookItemCreateVC" bundle:nil];

    // Pass the selected object to the new view controller.
    [scrapbookItemCreateVC editItem:self.item];
    scrapbookItemCreateVC.model = self.model;
    
    // Push the view controller.
    [self.navigationController pushViewController:scrapbookItemCreateVC animated:YES];
}

- (void)showItemAtIndex:(int)index
{
    self.itemIndex = index;
    self.item = [self.model itemAtIndex:index];
    
    // Read image from documents folder
    NSData *pngData = [NSData dataWithContentsOfFile:self.item.path];
    UIImage *image = [UIImage imageWithData:pngData];
    
    // Show image at full width of screen
    int screenWidth = self.view.bounds.size.width;
    float imageRatio = image.size.height / image.size.width;
    float scaledImageHeight = screenWidth * imageRatio;
    float scaledImageWidth = screenWidth;
    if(scaledImageHeight >= self.view.bounds.size.height - 150) {
        scaledImageHeight = scaledImageHeight-66;
        scaledImageWidth = scaledImageHeight/imageRatio;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-scaledImageWidth)/2, 0, scaledImageWidth, scaledImageHeight)];
    [imageView setImage:image];
    [self.view addSubview:imageView];
    
    // Show title below image
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, scaledImageHeight, screenWidth, 30)];
    title.text = self.item.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor blackColor];
    [self.view addSubview:title];
    
    // Show description below title
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(0, 26+scaledImageHeight, screenWidth, 30)];
    description.text = self.item.description;
    description.font = [UIFont systemFontOfSize:14];
    description.textAlignment = NSTextAlignmentCenter;
    description.textColor = [UIColor grayColor];
    [self.view addSubview:description];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
