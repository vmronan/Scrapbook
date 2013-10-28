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
        [self.view setBackgroundColor:[UIColor whiteColor]];
                
        // Make save button in navigation bar
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
        [self.navigationItem setRightBarButtonItem:saveButton animated:NO];
    }
    return self;
}

- (void)showView
{
    // Get original image
    NSData *pngOrigData = [NSData dataWithContentsOfFile:self.item.origPath];
    self.origImage = [UIImage imageWithData:pngOrigData];
    
    // Get current image
    NSData *pngCurrentData = [NSData dataWithContentsOfFile:self.item.currentPath];
    UIImage *currentImage = [UIImage imageWithData:pngCurrentData];
    // Get adjusted height of current image
    
    // Define filter row's height
    int filterRowHeight = 80*self.origImage.size.height/self.origImage.size.width+20;
    
    // Get current image (with maximum height of the screen's width)
    int screenWidth = self.view.bounds.size.width;
    self.imageView = [self setImageViewForImage:currentImage withMaxWidth:screenWidth maxHeight:screenWidth atHeight:filterRowHeight];
    [self.imageView setImage:currentImage];
    
    // Define other heights
    int imageHeight = self.imageView.bounds.size.height;
    int buttonRowHeight = 40;
    int textFieldHeight = 30;
    int space = 4;
    
    // Initialize scrollview
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    self.scrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    self.scrollView.contentSize=CGSizeMake(320,filterRowHeight+imageHeight+buttonRowHeight+2*textFieldHeight+5*space);
    self.scrollView.userInteractionEnabled = YES;
    
    // Show filter options with original image
    self.filters = [[NSArray alloc] initWithObjects:
                        [CIFilter filterWithName:@"CIVignette"],
                        [CIFilter filterWithName:@"CIPhotoEffectChrome"],
                        [CIFilter filterWithName:@"CIColorPosterize"],
                        [CIFilter filterWithName:@"CIPixellate"], nil];
    self.filterNames = [[NSArray alloc] initWithObjects:@"Normal", @"Vignette", @"Chrome", @"Posterize", @"Pixellate", nil];
    self.filtersView = [[FiltersView alloc] initWithFrame:CGRectMake(0, 0, 320, filterRowHeight) image:self.origImage target:self filters:self.filters filterNames:self.filterNames];
    [self.filtersView showFilters];
    self.filtersView.userInteractionEnabled = YES;
    
    // Show crop button
    self.cropButton = [[UIButton alloc] initWithFrame:CGRectMake(10, filterRowHeight+imageHeight+space, buttonRowHeight, buttonRowHeight)];
    [self.cropButton setImage:[UIImage imageNamed:@"crop.png"] forState:UIControlStateNormal];
    [self.cropButton addTarget:self action:@selector(cropButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    // Show title field
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(10, filterRowHeight+imageHeight+buttonRowHeight+2*space, 300, 30)];
    [self.titleField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.titleField setPlaceholder:@"Title"];
    
    // Show description field
    self.descriptionField = [[UITextField alloc] initWithFrame:CGRectMake(10, filterRowHeight+imageHeight+buttonRowHeight+textFieldHeight+3*space, 300, 30)];
    [self.descriptionField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.descriptionField setPlaceholder:@"Description"];
    
    // Show title and description in fields if they're already set
    if(self.item.rowId != -1) {
        [self.titleField setText:self.item.title];
        [self.descriptionField setText:self.item.description];
    }
    
    // Add buttons and text fields to view
    [self.scrollView addSubview:self.filtersView];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.cropButton];
    [self.scrollView addSubview:self.titleField];
    [self.scrollView addSubview:self.descriptionField];
    
    // Hide keyboard when user touches outside it
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.scrollView addGestureRecognizer:tap];
    self.scrollView.userInteractionEnabled=YES;
    
    // Set view to scrollview
    self.view=self.scrollView;
}

- (void)applyFilter:(UITapGestureRecognizer *)sender
{
    NSLog(@"applying filter");
    if([sender.view tag] == -1) {
        // Show original image
        [self.imageView setImage:self.origImage];
    }
    else {
        CIFilter *filter = [self.filters objectAtIndex:[sender.view tag]];
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CIImage *original = [CIImage imageWithCGImage:self.origImage.CGImage];
        CIFilter *fadeFilter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
        [fadeFilter setValue:original forKey:@"inputImage"];
        CIImage *newImage = [fadeFilter valueForKey:@"outputImage"];
        
        [filter setValue:newImage forKey:@"inputImage"];
        CIImage *newNewImage = [filter valueForKey:@"outputImage"];
        
        CGImageRef cgimage = [context createCGImage:newNewImage fromRect:[newNewImage extent]];
        UIImage *newUIImage = [UIImage imageWithCGImage:cgimage];
        CGImageRelease(cgimage);
        
        [self.imageView setImage:newUIImage];
    }
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
    // Save image
    self.item.currentPath = [LocalPhotoSaver saveEditedImage:self.imageView.image fromOrigPath:self.item.origPath];

    self.item.title = self.titleField.text;
    self.item.description = self.descriptionField.text;
    [self.model saveItem:self.item];
}

- (UIImageView *)setImageViewForImage:(UIImage *)image withMaxWidth:(int)maxWidth maxHeight:(int)maxHeight atHeight:(int)y
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
    
    return [[UIImageView alloc] initWithFrame:CGRectMake((maxWidth-width)/2, y, width, height)];
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
