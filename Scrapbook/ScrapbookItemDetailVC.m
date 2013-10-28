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
    ScrapbookItemEditVC *scrapbookItemEditVC = [[ScrapbookItemEditVC alloc] initWithNibName:@"ScrapbookItemEditVC" bundle:nil];

    // Pass the selected object to the new view controller.
    scrapbookItemEditVC.item = self.item;
    [scrapbookItemEditVC showView];
    scrapbookItemEditVC.model = self.model;
    
    // Push the view controller.
    [self.navigationController pushViewController:scrapbookItemEditVC animated:YES];
}

- (void)showItemAtIndex:(int)index
{
    self.itemIndex = index;
    self.item = [self.model itemAtIndex:index];
    
    // Read image from documents folder
    NSData *pngData = [NSData dataWithContentsOfFile:self.item.currentPath];
    UIImage *image = [UIImage imageWithData:pngData];
    
    // Show image with height of the screen's width
    int screenWidth = self.view.bounds.size.width;
    float scaledImageWidth = image.size.width / image.size.height * screenWidth;
    UIImageView *imageView = [self setImageViewForImage:image withMaxWidth:self.view.bounds.size.width maxHeight:self.view.bounds.size.height - 64];
    [imageView setImage:image];
    [self.view addSubview:imageView];
    
    // Show title below image
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bounds.size.height, screenWidth, 30)];
    title.text = self.item.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor blackColor];
    [self.view addSubview:title];
    
    // Show description below title
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(0, 30+imageView.bounds.size.height, screenWidth, 30)];
    description.text = self.item.description;
    description.font = [UIFont systemFontOfSize:14];
    description.textAlignment = NSTextAlignmentCenter;
    description.textColor = [UIColor grayColor];
    [self.view addSubview:description];
    
    // Show Twitter posting button below description
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [postButton setTitle:@"Post to Twitter" forState:UIControlStateNormal];
    [postButton setFrame:CGRectMake(10, screenWidth+60, 300, 30)];
    [postButton addTarget:self action:@selector(presentPostComposer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postButton];
}

- (UIImageView *)setImageViewForImage:(UIImage *)image withMaxWidth:(int)maxWidth maxHeight:(int)maxHeight
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width, height;    // to be defined
    
    if(imageHeight/imageWidth > 1.0) {
        // Image is tall (or square)
        height = maxHeight;
        width = height / imageHeight * imageWidth;
    }
    else {
        // Image is wide
        width = maxWidth;
        height = width / imageWidth * imageHeight;
    }
    
    return [[UIImageView alloc] initWithFrame:CGRectMake((maxWidth-width)/2, 0, width, height)];
}

- (void)presentPostComposer
{
    SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [composeViewController setInitialText:[NSString stringWithFormat:@"%@ - %@", self.item.title, self.item.description]];
    [composeViewController addImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:self.item.currentPath]]];
    [self presentViewController:composeViewController animated:YES completion:nil];
}

-(void)dismissKeyboard {
    NSLog(@"dismissing keyboard");
//    [self.titleField resignFirstResponder];
//    [self.descriptionField resignFirstResponder];
}

/*
 // Hide keyboard when user touches outside it
 UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
 initWithTarget:self
 action:@selector(dismissKeyboard)];
 [self.scrollView addGestureRecognizer:tap];
 
 // Show title and description in fields if they're already set
 if(self.item.rowId != -1) {
 [self.titleField setText:self.item.title];
 [self.descriptionField setText:self.item.description];
 }
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
