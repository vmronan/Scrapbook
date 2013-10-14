//
//  FlickrVCViewController.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/29/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "FlickrVC.h"

@interface FlickrVC ()

@end

@implementation FlickrVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self.view setFrame:[[UIScreen mainScreen] bounds]];
    }
    return self;
}

+ (UIColor*)flickrPink
{
    return [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:132.0f/255.0f alpha:1.0f];
}

- (void)didPressSearch
{    
    // Clear images already there
    self.photoURLs = [[NSMutableArray alloc] initWithCapacity:0];
    
    // Dismiss keyboard if it's not already gone
    if([self.queryField isFirstResponder]) {
        [self.queryField resignFirstResponder];
    }
    
    // Show loading spinner
    self.loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingSpinner.center = self.view.center;
    [self.view addSubview:self.loadingSpinner];
    [self.loadingSpinner startAnimating];
    
    NSURL* queryURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=8231ce5e99b41da4aa177a7c07a1fdcd&tags=%@&format=json&nojsoncallback=1", [self queryField].text]];
    
    self.tagSearcher = [[PhotoTagSearcher alloc] initWithQuery:queryURL target:self action:@selector(handleFlickrResponse:)];
}


- (void)handleFlickrResponse:(NSMutableDictionary *)response
{
    if([[response objectForKey:@"stat"] isEqual:@"ok"]) {
        NSMutableArray *photos = [[response objectForKey:@"photos"] objectForKey:@"photo"];
        
        for(int i = 0; i < [photos count]; i++) {
            NSMutableDictionary *photo = [photos objectAtIndex:i];
            NSString *photoUrl = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
            [self.photoURLs addObject:photoUrl];
        }
    }
    
    [self.tableView reloadData];
    [self.loadingSpinner stopAnimating];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    
    self.queryField = [[UITextField alloc] initWithFrame:CGRectMake(4, 4, 272, 32)];
    [self.queryField setPlaceholder:@"Search Flickr by tag"];
    [self.queryField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.queryField setTextColor:[FlickrVC flickrPink]];
    [header addSubview:self.queryField];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(278, 0, 40, 40)];
    [searchButton setTitle:@"GO" forState:UIControlStateNormal];
    [searchButton setTitleColor:[FlickrVC flickrPink] forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [searchButton addTarget:self action:@selector(didPressSearch) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:searchButton];
    return header;
}

- (void) drawPlaceholderInRect:(CGRect)rect {
    [[UIColor greenColor] setFill];
    [self.queryField.placeholder drawInRect:rect withFont:[UIFont systemFontOfSize:16]];
}
                          
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 40;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photoURLs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get image
    NSURL *photoURL = [[NSURL alloc] initWithString:[self.photoURLs objectAtIndex:indexPath.row]];
    NSData *data = [NSData dataWithContentsOfURL:photoURL];
    UIImage *image = [UIImage imageWithData:data];
    int screenWidth = self.view.bounds.size.width;
    
    // Place image in imageview of correct size
    float imageRatio = image.size.height / image.size.width;
    float scaledImageHeight = screenWidth * imageRatio;
    UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, scaledImageHeight)];
    [photoView setImage:image];
    
    [[cell contentView] setTag:scaledImageHeight];
    [[cell contentView] addSubview:photoView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [[cell contentView] tag];
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
    // Create the next view controller.
    ScrapbookItemEditVC *scrapbookItemCreateVC = [[ScrapbookItemEditVC alloc] initWithNibName:@"ScrapbookItemCreateVC" bundle:nil];

    // Pass the selected object to the new view controller.
    ScrapbookItem *item = [[ScrapbookItem alloc] initWithURL:[self.photoURLs objectAtIndex:indexPath.row] title:nil description:nil rowId:-1];
    [scrapbookItemCreateVC editItem:item];
    scrapbookItemCreateVC.model = self.model;
    
    // Push the view controller.
    [self.navigationController pushViewController:scrapbookItemCreateVC animated:YES]; 
}
 


@end
