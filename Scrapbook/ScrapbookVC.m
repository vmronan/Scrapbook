//
//  ScrapbookViewController.m
//  Scrapbook
//
//  Created by Vanessa Ronan on 9/28/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "ScrapbookVC.h"

@interface ScrapbookVC ()

@end

@implementation ScrapbookVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self setTitle:@"My Scrapbook"];
        self.navigationItem.hidesBackButton = YES;
        
        self.items = [self.model allItems];
        
        self.imagePickerVC = [[UIImagePickerController alloc] init];
        [self.imagePickerVC setDelegate:self];
        
        // Make search and gallery buttons in navigation bar
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonPressed)];
        UIBarButtonItem *galleryButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gallery.png"] style:UIBarButtonItemStylePlain target:self action:@selector(presentImagePickerView)];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addButton, galleryButton, nil]];
        
        // Register the type of view to create for a table cell
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return self;
}

- (void)searchButtonPressed
{
    // Go to view that lets you search for photos on Flickr and Instagram
    self.photoSearchVC = [[PhotoSearchVC alloc] initWithModel:self.model];
    [self.navigationController pushViewController:self.photoSearchVC animated:YES];
}

- (void)presentImagePickerView
{
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.imagePickerVC dismissViewControllerAnimated:YES completion:nil];
    EditPhotoVC *scrapbookItemEditVC = [[EditPhotoVC alloc] initWithNibName:@"EditPhotoVC" bundle:nil];
    ScrapbookItem *item = [[ScrapbookItem alloc] initWithImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] title:nil description:nil rowId:-1];
    scrapbookItemEditVC.item = item;
    [scrapbookItemEditVC showView];
    scrapbookItemEditVC.model = self.model;
    
    [self.navigationController pushViewController:scrapbookItemEditVC animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePickerVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)update
{
    self.items = [self.model allItems];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.model numItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    ScrapbookItem *item = [self.model itemAtIndex:indexPath.row];
    ScrapbookItemCellView *cellView = [[ScrapbookItemCellView alloc] initWithItem:item screenWidth:self.view.bounds.size.width];
    [[cell contentView] setTag:cellView.tag];
    [[cell contentView] addSubview:cellView];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.model deleteItemAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Show item's details when it's clicked
    self.scrapbookItemDetailVC = [[ScrapbookItemDetailVC alloc] initWithNibName:@"ScrapbookItemDetailVC" bundle:nil];
    self.scrapbookItemDetailVC.model = self.model;
    [self.scrapbookItemDetailVC showItemAtIndex:indexPath.row];
    [self.navigationController pushViewController:self.scrapbookItemDetailVC animated:YES];
}

@end
