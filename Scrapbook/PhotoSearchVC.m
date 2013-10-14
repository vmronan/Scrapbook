//
//  PhotoSearchViewController.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "PhotoSearchVC.h"

@interface PhotoSearchVC ()

@end

@implementation PhotoSearchVC

- (id)initWithModel:(ScrapbookModel*)model
{
    self = [super init];
    if (self) {
        self.navigationController.navigationBar.translucent = NO;

        [self.navigationItem setTitle:@"Search for Photos"];
        
        // Create the Flickr view controller
        self.flickrViewController = [[FlickrVC alloc] init];
        self.flickrViewController.model = model;
        self.flickrViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Flickr" image:[UIImage imageNamed:@"flickr.png"] tag:1];
        self.flickrViewController.tabBar = self.tabBar;
        [self.flickrViewController setTabBarTintColor];
        
        // Create the Instagram view controller
        self.instaViewController = [[InstagramVC alloc] init];
        self.instaViewController.model = model;
        self.instaViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Instagram" image:[UIImage imageNamed:@"instagram.png"] tag:2];
        self.instaViewController.tabBar = self.tabBar;
        
        // Add the view controllers to the tab bar
        [self setViewControllers:[NSArray arrayWithObjects:self.flickrViewController, self.instaViewController, nil] animated:YES];
    }
    return self;
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
