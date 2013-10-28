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
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        // Make crop button in navigation bar
        UIBarButtonItem *cropButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"crop.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleCrop)];
        // Make save button in navigation bar
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
        
        [self.navigationItem setRightBarButtonItems:[[NSArray alloc] initWithObjects:saveButton, cropButton, nil] animated:YES];
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
    
    // Define filter row's height
    int filterRowHeight = 80*self.origImage.size.height/self.origImage.size.width+16;
    
    // Get view for current image (with maximum height of the screen's width)
    int screenWidth = self.view.bounds.size.width;
    self.photoView = [[PhotoView alloc] initWithFrame:[self getPhotoFrameForImage:currentImage withMaxWidth:screenWidth maxHeight:screenWidth atHeight:filterRowHeight] photo:currentImage];
    
    // Initialize scrollview
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    self.scrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    self.scrollView.contentSize=CGSizeMake(320,filterRowHeight+self.photoView.bounds.size.height);
    
    // Show filter options with original image
    self.filters = [[NSArray alloc] initWithObjects:
                        [CIFilter filterWithName:@"CIVignette"],
                        [CIFilter filterWithName:@"CIPhotoEffectChrome"],
                        [CIFilter filterWithName:@"CIColorPosterize"],
                        [CIFilter filterWithName:@"CIPixellate"], nil];
    self.filterNames = [[NSArray alloc] initWithObjects:@"Original", @"Vignette", @"Chrome", @"Posterize", @"Pixellate", nil];
    self.filtersView = [[FiltersView alloc] initWithFrame:CGRectMake(0, 0, 320, filterRowHeight) image:self.origImage target:self filters:self.filters filterNames:self.filterNames];
    [self.filtersView showFilters];
    
    // Add buttons and text fields to view
    [self.scrollView addSubview:self.filtersView];
    [self.scrollView addSubview:self.photoView];
    
    // Set view to scrollview
    self.view=self.scrollView;
}

- (void)applyFilter:(UITapGestureRecognizer *)sender
{
    NSLog(@"applying filter");
    if([sender.view tag] == -1) {
        // Show original image
        [self.photoView showPhoto:self.origImage];
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
        
        [self.photoView showPhoto:newUIImage];
    }
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)toggleCrop
{
    [self.photoView toggleCropRegion];
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
    UIImage *img = [self.photoView getCroppedImage];
    NSLog(@"saving image of size %f x %f", img.size.width, img.size.height);
    self.item.currentPath = [LocalPhotoSaver saveEditedImage:[self.photoView getCroppedImage] fromOrigPath:self.item.origPath];
    [self.model saveItem:self.item];
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
