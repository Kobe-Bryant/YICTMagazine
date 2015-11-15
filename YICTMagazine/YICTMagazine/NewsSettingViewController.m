//
//  NewsSettingViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-20.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "NewsSettingViewController.h"
#import "NewsCategory.h"
#import "AppSettingKeys.h"
#import "AppDelegate.h"
#import "ReceiveDevice.h"

@interface NewsSettingViewController ()

@property (nonatomic, strong) NSArray *newsCategoryArray;
@property (nonatomic, strong) NSMutableArray *selectedOptions;

@end

@implementation NewsSettingViewController

@synthesize dataObject;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Title
    self.title = NSLocalizedString(@"Type", nil);
    
    
    
    // Navigation bar back button
    UIImage *backButtonImage = [UIImage imageNamed:@"Back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    
    // Background
    self.tableView.backgroundView = nil;
    [self.view setBackgroundColor:[UIColor
                                   colorWithRed:(236.0/255.0)
                                   green:(236.0/255.0)
                                   blue:(236.0/255.0)
                                   alpha:1.0]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    // data
    _newsCategoryArray = self.dataObject;
    for (NewsCategory *nc in _newsCategoryArray)
    {
    }
    
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *newsCategoryIdArray = [userDefaults objectForKey:kNewsCategoryType];
    self.selectedOptions = [[NSMutableArray alloc] init];
    if ([newsCategoryIdArray count] > 0)
    {
        for (NSNumber *newsCategoryId in newsCategoryIdArray)
        {
            for (int i = 0; i < [_newsCategoryArray count]; i++)
            {
                NewsCategory *newsCategory = [_newsCategoryArray objectAtIndex:i];
                if (newsCategoryId == newsCategory.newsCategoryId)
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.selectedOptions addObject:indexPath];
                }
            }
        }
    }
    else
    {
        for (int i = 0; i < [_newsCategoryArray count]; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.selectedOptions addObject:indexPath];
        }
    }
    

//    NSArray *newsCategoryIdArray = [
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(void)back
{
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
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
    return [_newsCategoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor
                                colorWithRed:(51.0f / 255.0f)
                                green:(51.0f / 255.0f)
                                blue:(51.0f / 255.0f)
                                alpha:1.0f];
    
//    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == 0)
    {
        UIImage *backgroundImage = [UIImage imageNamed:@"SettingCell1_1.png"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        cell.backgroundView = backgroundImageView;
    }
    else
    {
        UIImage *backgroundImage = [UIImage imageNamed:@"SettingCell1_2.png"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        cell.backgroundView = backgroundImageView;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    else
    {
        cell.textLabel.backgroundColor = [UIColor whiteColor];
    }

    NewsCategory *newsCategory = [_newsCategoryArray objectAtIndex:indexPath.row];
    cell.textLabel.text = newsCategory.title;
    if ([self.selectedOptions containsObject:indexPath])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        UIImage *checkedImage = [UIImage imageNamed:@"Checked.png"];
        cell.accessoryView = [[UIImageView alloc] initWithImage:checkedImage];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        cell.accessoryView = nil;   
    }
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if ([self.selectedOptions containsObject:indexPath])
        {
            [self.selectedOptions removeObject:indexPath];
        }
        else
        {
            [self.selectedOptions addObject:indexPath];
        }
        
        NSMutableArray *newIdArray = [[NSMutableArray alloc] init];
        for (NSIndexPath *_indexPath in self.selectedOptions)
        {
            NewsCategory *newsCategory = [_newsCategoryArray objectAtIndex:_indexPath.row];
            [newIdArray addObject:newsCategory.newsCategoryId];
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:newIdArray forKey:kNewsCategoryType];
        
        if ([appDelegate.deviceTokenString length] > 0)
        {
            ReceiveDevice *receiveDevice = [[ReceiveDevice alloc] init];
            receiveDevice.deviceTokenString = appDelegate.deviceTokenString;
            [receiveDevice syncNotificationNewsCategoryList:newIdArray];
        }
        
        [tableView reloadData];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                            message:NSLocalizedString(@"Please connect to network.", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

@end
