//
//  InstagramVC.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/29/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "InstagramVC.h"

@interface InstagramVC ()

@end

@implementation InstagramVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self.view setFrame:[[UIScreen mainScreen] bounds]];
    }
    return self;
}

+ (UIColor*)instagramBlue
{
    return [UIColor colorWithRed:81.0f/255.0f green:127.0f/255.0f blue:164.0f/255.0f alpha:1.0f];
}

- (void)setTabBarTintColor
{
    self.tabBar.tintColor = [InstagramVC instagramBlue];
}

- (void)didPressSearch
{
    // Clear images already there
    self.photos = [[NSMutableArray alloc] initWithCapacity:0];
    
    // Dismiss keyboard if it's not already gone
    if([self.queryField isFirstResponder]) {
        [self.queryField resignFirstResponder];
    }
    
    // Show loading spinner
    self.loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingSpinner.center = self.view.center;
    [self.loadingSpinner setColor:[InstagramVC instagramBlue]];
    [self.view addSubview:self.loadingSpinner];
    [self.loadingSpinner startAnimating];
    
    NSURL* queryURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=52b557afb1c64d5aa7480bef6c368f3e", [self queryField].text]];
    
    self.tagSearcher = [[PhotoTagSearcher alloc] initWithQuery:queryURL target:self action:@selector(handleInstagramResponse:)];
}

- (void)handleInstagramResponse:(NSMutableDictionary *)response
{
    NSMutableArray *photos = [response objectForKey:@"data"];
    
    for(int i = 0; i < [photos count]; i++) {
        NSMutableDictionary *photo = [photos objectAtIndex:i];
        NSString *photoUrl = [[[photo objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"];
        InternetImageDownloader *download = [[InternetImageDownloader alloc] initWithURLFromString:photoUrl];
        download.target = self;
        download.action = @selector(downloadFinished:);
    }
}

- (void)downloadFinished:(UIImage*)image
{
    [self.photos addObject:image];
    [self.tableView reloadData];
    [self.loadingSpinner stopAnimating];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    // set needs layout in viewdidappear
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    
    self.queryField = [[UITextField alloc] initWithFrame:CGRectMake(4, 4, 272, 32)];
    [self.queryField setPlaceholder:@"Search Instagram by tag"];
    [self.queryField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.queryField setTextColor:[InstagramVC instagramBlue]];
    [header addSubview:self.queryField];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(278, 0, 40, 40)];
    [searchButton setTitle:@"GO" forState:UIControlStateNormal];
    [searchButton setTitleColor:[InstagramVC instagramBlue] forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [searchButton addTarget:self action:@selector(didPressSearch) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:searchButton];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 40;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self setTabBarTintColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get image
    UIImage *image = [self.photos objectAtIndex:indexPath.row];
    int screenWidth = self.view.bounds.size.width;
    
    // Place image in imageview of correct size
    UIImageView *photoView = [[UIImageView alloc] initWithImage:image];
    [photoView setFrame:CGRectMake(0, 0, screenWidth, screenWidth)];
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Show imageview
    [[cell contentView] addSubview:photoView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Height of each row is the width of the screen since Instagram photos are square
    return self.view.bounds.size.width;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    ScrapbookItemEditVC *scrapbookItemEditVC = [[ScrapbookItemEditVC alloc] initWithNibName:@"ScrapbookItemEditVC" bundle:nil];
    
    // Pass the selected object to the new view controller.
    ScrapbookItem *item = [[ScrapbookItem alloc] initWithImage:[self.photos objectAtIndex:indexPath.row] title:nil description:nil rowId:-1];
    [scrapbookItemEditVC editItem:item];
    scrapbookItemEditVC.model = self.model;
    
    // Push the view controller.
    [self.navigationController pushViewController:scrapbookItemEditVC animated:YES];
    
}

@end
