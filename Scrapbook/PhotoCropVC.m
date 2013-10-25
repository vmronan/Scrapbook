//
//  PhotoCropVC.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 10/24/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "PhotoCropVC.h"

@interface PhotoCropVC ()

@end

@implementation PhotoCropVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setTitle:@"Crop photo"];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
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
    [scrapbookItemEditVC editItem:self.item];
    scrapbookItemEditVC.model = self.model;
    
    // Push the view controller.
    [self.navigationController pushViewController:scrapbookItemEditVC animated:YES];
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
    self.imageView = [self setImageViewForImage:image withMaxWidth:screenWidth maxHeight:screenHeight];
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
    
//    NSLog(@"max height: %d, max width: %d, imageHeight: %f, imageWidth: %f, height: %f, width: %f", maxHeight, maxWidth, imageHeight, imageWidth, height, width);
    
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
