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
                
        // Make save button in navigation bar
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
        [self.navigationItem setRightBarButtonItem:saveButton animated:NO];
    }
    return self;
}

- (void)loadView
{
    int filterRowHeight = 80;
    int imageHeight = self.imageView.bounds.size.height;
    int buttonRowHeight = 40;
    int textFieldHeight = 30;
    int space = 4;
    
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    self.scrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    self.scrollView.contentSize=CGSizeMake(320,filterRowHeight+imageHeight+buttonRowHeight+2*textFieldHeight+5*space);
    
    // do any further configuration to the scroll view
    // add a view, or views, as a subview of the scroll view.
    
    self.cropButton = [[UIButton alloc] initWithFrame:CGRectMake(10, filterRowHeight+imageHeight+space, buttonRowHeight, buttonRowHeight)];
    [self.cropButton setImage:[UIImage imageNamed:@"crop.png"] forState:UIControlStateNormal];
    [self.cropButton addTarget:self action:@selector(cropButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(10, filterRowHeight+imageHeight+buttonRowHeight+2*space, 300, 30)];
    [self.titleField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.titleField setPlaceholder:@"Title"];
    
    self.descriptionField = [[UITextField alloc] initWithFrame:CGRectMake(10, filterRowHeight+imageHeight+buttonRowHeight+textFieldHeight+3*space, 300, 30)];
    [self.descriptionField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.descriptionField setPlaceholder:@"Description"];
    
    if(self.item.rowId != -1) {
        [self.titleField setText:self.item.title];
        [self.descriptionField setText:self.item.description];
    }
    
    // Show buttons and text fields
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.cropButton];
    [self.scrollView addSubview:self.titleField];
    [self.scrollView addSubview:self.descriptionField];
    
    // Hide keyboard when user touches outside it
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.scrollView addGestureRecognizer:tap];
    
    // Set view to scrollview
    self.view=self.scrollView;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)cropButtonPressed
{
    [self saveItem];
    
    // Go to crop view
    PhotoEditVC *photoCropVC = [[PhotoEditVC alloc] init];
    photoCropVC.model = self.model;
    photoCropVC.item = self.item;
    [photoCropVC showOrigPhoto];       // show original photo to crop
    [self.navigationController pushViewController:photoCropVC animated:YES];
}

- (void)saveButtonPressed
{
    [self saveItem];
    
    // Go to main scrapbook view
    ScrapbookVC *scrapbookVC = [[ScrapbookVC alloc] init];
    scrapbookVC.model = self.model;
    [scrapbookVC update];
    [self.navigationController pushViewController:scrapbookVC animated:YES];
}

- (void)saveItem
{
    self.item.title = self.titleField.text;
    self.item.description = self.descriptionField.text;
    [self.model saveItem:self.item];
}

- (void)editItem:(ScrapbookItem*)item
{
    self.item = item;
    [self showPhotoAtPath:item.currentPath];
}

- (void)editPhotoAtPath:(NSString *)path
{
    [self showPhotoAtPath:path];

}

- (void)showPhotoAtPath:(NSString *)path
{
    // Read image from documents folder
    NSData *pngData = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage imageWithData:pngData];
    
    // Show image with height of the screen's width
    int screenWidth = self.view.bounds.size.width;
    self.imageView = [self setImageViewForImage:image withMaxWidth:screenWidth maxHeight:screenWidth];
    [self.imageView setImage:image];
//    [self.scrollView addSubview:self.imageView];
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
    
    return [[UIImageView alloc] initWithFrame:CGRectMake((maxWidth-width)/2, 80, width, height)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)dismissKeyboard {
    NSLog(@"dismissing keyboard");
    [self.titleField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
