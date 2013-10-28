//
//  PhotoCropVC.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/24/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "PhotoEditVC.h"

@interface PhotoEditVC ()

@end

@implementation PhotoEditVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setTitle:@"Edit photo"];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        [self showFilterButtons];
        
        // Make done button in navigation bar
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
    }
    return self;
}

- (void)doneButtonPressed
{
    // Crop image
    UIImage *croppedImage = [self getCroppedImage];
    
    // Save image
    self.item.currentPath = [LocalPhotoSaver saveEditedImage:croppedImage fromOrigPath:self.item.origPath];
    
    // Go back to edit view
    ScrapbookItemEditVC *scrapbookItemEditVC = [[ScrapbookItemEditVC alloc] initWithNibName:@"ScrapbookItemEditVC" bundle:nil];
    [scrapbookItemEditVC setItem:self.item];
    [scrapbookItemEditVC loadView];
    scrapbookItemEditVC.model = self.model;
    
    // Push the view controller.
    [self.navigationController pushViewController:scrapbookItemEditVC animated:YES];
}

- (void)showFilterButtons
{
    int screenWidth = self.view.bounds.size.width;
    int screenHeight = self.view.bounds.size.height;
    
    self.vignetteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.vignetteButton setFrame:CGRectMake(0, screenHeight-94, screenWidth/3, 30)];
    [self.vignetteButton setTitle:@"Vignette" forState:UIControlStateNormal];
    [self.vignetteButton addTarget:self action:@selector(applyVignetteFilter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.vignetteButton];
    
    self.chromeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.chromeButton setFrame:CGRectMake(screenWidth/3, screenHeight-94, screenWidth/3, 30)];
    [self.chromeButton setTitle:@"Chrome" forState:UIControlStateNormal];
    [self.chromeButton addTarget:self action:@selector(applyChromeFilter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chromeButton];
    
    self.posterizeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.posterizeButton setFrame:CGRectMake(screenWidth*2/3, screenHeight-94, screenWidth/3, 30)];
    [self.posterizeButton setTitle:@"Posterize" forState:UIControlStateNormal];
    [self.posterizeButton addTarget:self action:@selector(applyPosterizeFilter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.posterizeButton];
}

- (UIImage *)getCroppedImage
{
    // Get temporary UIImage of pixels in crop region from the original image
    CGImageRef croppedCGImage = CGImageCreateWithImageInRect(self.imageView.image.CGImage, [self.cropRegionView cropBounds]);
    UIImage *temp = [UIImage imageWithCGImage:croppedCGImage];
    
    // Draw UIImage with the new dimensions in the image context
    UIGraphicsBeginImageContext(CGSizeMake(320.0, 320.0));
    [temp drawInRect:CGRectMake(0, 0, 320, 320)];
    UIImage *croppedUIImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the graphics context and release the CGImage
    UIGraphicsEndImageContext();
    CGImageRelease(croppedCGImage);
    
    return croppedUIImage;
}

- (void)showOrigPhoto
{
    // Read image from documents folder
    NSData *pngData = [NSData dataWithContentsOfFile:self.item.origPath];
    UIImage *image = [UIImage imageWithData:pngData];
    
    // Show image with height of the screen's width
    int screenWidth = self.view.bounds.size.width;
    int screenHeight = self.view.bounds.size.height-64;
    
    // Show image of correct size in image view
    self.imageView = [self setImageViewForImage:image withMaxWidth:screenWidth maxHeight:screenHeight-30];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setImage:image];
    [self.view addSubview:self.imageView];
    
    // Pass touches in the imageview to the crop region
    [self.imageView setUserInteractionEnabled:YES];
    
    // Show crop region
    [self showCropRegion];
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

    return [[UIImageView alloc] initWithFrame:CGRectMake((maxWidth-width)/2, (maxHeight-height)/2, width, height)];
}

- (void)showCropRegion
{
    // Create and show cropping box
    self.cropRegionView = [[CropRegionView alloc] initWithFrame:CGRectMake(self.imageView.bounds.size.width/2-50, self.imageView.bounds.size.height/2-50, 100, 100)];
    self.cropRegionView.parentView = self.imageView;
    self.cropRegionView.imageBoundsInView = CGRectMake(self.imageView.bounds.origin.x, self.imageView.bounds.origin.y, self.imageView.bounds.size.width, self.imageView.bounds.size.height);
    [self.imageView addSubview:self.cropRegionView];
}

- (void)applyVignetteFilter
{
    [self applyFilter:@"CIVignette"];
}

- (void)applyChromeFilter
{
    [self applyFilter:@"CIPhotoEffectChrome"];
}

- (void)applyPosterizeFilter
{
    [self applyFilter:@"CIColorPosterize"];
}

- (void)applyFilter:(NSString*)filterName
{
    if (self.imageView.image != nil) {
        CIContext *context = [CIContext contextWithOptions:nil];
        
        NSData *pngData = [NSData dataWithContentsOfFile:self.item.origPath];
        UIImage *image = [UIImage imageWithData:pngData];
        
        CIImage *original = [CIImage imageWithCGImage:image.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
        [filter setValue:original forKey:@"inputImage"];
        CIImage *newImage = [filter valueForKey:@"outputImage"];

        CIFilter *sepia = [CIFilter filterWithName:filterName];
        [sepia setValue:newImage forKey:@"inputImage"];
        CIImage *newNewImage = [sepia valueForKey:@"outputImage"];
        
        CGImageRef cgimage = [context createCGImage:newNewImage fromRect:[newNewImage extent]];
        
        UIImage *newUIImage = [UIImage imageWithCGImage:cgimage];
        CGImageRelease(cgimage);
        
        // uncomment this line if you want to skip from CI to UI image... avoiding CG
        // this will allow you to avoid the need for creating a context and releasing a created CGImage
        //UIImage *newUIImage = [UIImage imageWithCIImage:newNewImage];
        
        [self.imageView setImage:newUIImage];
    }
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
