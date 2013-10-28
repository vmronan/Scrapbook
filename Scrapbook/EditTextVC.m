//
//  ScrapbookItemEditTextVC.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "EditTextVC.h"
#import "ScrapbookVC.h"

@interface EditTextVC ()

@end

@implementation EditTextVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"Edit"];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        // Hide keyboard when user touches outside it
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:tap];
        
        // Make save button in navigation bar
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButtonPressed)];
        [self.navigationItem setRightBarButtonItem:saveButton];
    }
    return self;
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
    // Save image
    self.item.title = self.titleField.text;
    self.item.description = self.descriptionField.text;
    self.item.currentPath = [LocalPhotoSaver saveEditedImage:self.imageView.image fromOrigPath:self.item.origPath];
}

- (void)setupWithImage:(UIImage *)image
{
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 30)];
    [self.titleField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.titleField setPlaceholder:@"Title"];
    self.descriptionField = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-20, 30)];
    [self.descriptionField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.descriptionField setPlaceholder:@"Description"];
    // Show title and description in fields if they're already set
    if(self.item.rowId != -1) {
        [self.titleField setText:self.item.title];
        [self.descriptionField setText:self.item.description];
    }
    [self.view addSubview:self.titleField];
    [self.view addSubview:self.descriptionField];
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self.imageView setFrame:[self getPhotoFrameForImage:image withMaxWidth:self.view.bounds.size.width maxHeight:self.view.bounds.size.height atHeight:90]];
    [self.view addSubview:self.imageView];
    
}

- (CGRect)getPhotoFrameForImage:(UIImage *)image withMaxWidth:(int)maxWidth maxHeight:(int)maxHeight atHeight:(int)y
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
    
    return CGRectMake((maxWidth-width)/2, y, width, height);
}

-(void)dismissKeyboard {
    NSLog(@"dismissing keyboard");
    [self.titleField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
