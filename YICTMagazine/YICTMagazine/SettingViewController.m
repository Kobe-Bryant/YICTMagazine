//
//  SettingViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-19.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kClearCacheAlertViewTag 800

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "NewsSettingViewController.h"
#import "AboutViewController.h"
#import "AppSettingKeys.h"
#import "NewsCategory.h"
#import "ReceiveDevice.h"
#import "About.h"

@interface SettingViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *settingOptions;
@property (nonatomic, strong) NSArray *newsCategoryArray;

@end

@implementation SettingViewController

@synthesize sidebarDelegate;

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
    self.title = NSLocalizedString(@"Settings", nil);
    
    
    
    // Toggle sidebar button
    UIButton *toggleSidebarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleSidebarButton.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    NSString *toggleSidebarOptionImageName = [NSString stringWithFormat:@"SidebarOptionButton.png"];
    UIImage *toggleSidebarOptionImage = [UIImage imageNamed:toggleSidebarOptionImageName];
    [toggleSidebarButton setImage:toggleSidebarOptionImage forState:UIControlStateNormal];
    [toggleSidebarButton addTarget:self action:@selector(toggleSidebar:)
                  forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sidebarOptionButton = [[UIBarButtonItem alloc]
                                            initWithCustomView:toggleSidebarButton];
    self.navigationItem.leftBarButtonItem = sidebarOptionButton;
    
    
    
    // Background
    self.view.backgroundColor = [UIColor
                                 colorWithRed:(236.0f / 255.0f)
                                 green:(236.0f / 255.0f)
                                 blue:(236.0f / 255.0f)
                                 alpha:1.0f];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    // News category
    Result *result = [NewsCategory getList];
    _newsCategoryArray = result.data;
    

}

- (void)viewWillAppear:(BOOL)animated
{
    Result *result = [NewsCategory getList];
    _newsCategoryArray = result.data;
    [self.tableView reloadData];
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

- (void)toggleSidebar:(id)sender
{
    [self.sidebarDelegate toggleSidebrButtonPressed:self];
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
//    return [self.settingOptions count];
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    if (section == 0)
//    {
//        return 2;
//    }
//    else
//    {
        return 1;
//    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 35.0;
    }
    
    return 0.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        NSString *title = section == 0 ? NSLocalizedString(@"News Settings", nil) : NSLocalizedString(@"Automatic Download Settings", nil);
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 35.0f);
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(12.0f, 0.0f, tableView.bounds.size.width - 12.0f, 35.0f);
        titleLabel.textColor = [UIColor colorWithRed:(119.0f / 255.0f)
                                               green:(119.0f / 255.0f)
                                                blue:(119.0f / 255.0f)
                                               alpha:1.0f];
        titleLabel.backgroundColor = [UIColor colorWithRed:(236.0f / 255.0f)
                                                     green:(236.0f / 255.0f)
                                                      blue:(236.0f / 255.0f)
                                                     alpha:1.0f];
        titleLabel.text = title;
        [view addSubview:titleLabel];
        return view;
    }
    
    return [[UIView alloc] init];

}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3)
    {
        NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"Version %@", nil), [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 35.0f);
        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.frame = CGRectMake(12.0f, 0.0f, tableView.bounds.size.width - 12.0f, 35.0f);
        titleLabel.textColor = [UIColor colorWithRed:(119.0f / 255.0f)
                                               green:(119.0f / 255.0f)
                                                blue:(119.0f / 255.0f)
                                               alpha:1.0f];
        titleLabel.backgroundColor = [UIColor colorWithRed:(236.0f / 255.0f)
                                                     green:(236.0f / 255.0f)
                                                      blue:(236.0f / 255.0f)
                                                     alpha:1.0f];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.text = title;
        [titleLabel sizeToFit];
        titleLabel.frame = CGRectMake((self.view.frame.size.width - titleLabel.frame.size.width) / 2,
                                      4.0f,
                                      titleLabel.frame.size.width,
                                      titleLabel.frame.size.height);
        [view addSubview:titleLabel];
        return view;
    }
    
    return [[UIView alloc] init];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return NSLocalizedString(@"News Settings", nil);
    }
    else if(section == 1)
    {
        return NSLocalizedString(@"Automatic Download Settings", nil);
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                   0.0f,
                                                                   tableView.bounds.size.width,
                                                                   44.0f)];
    cell.textLabel.textColor = [UIColor
                                colorWithRed:(51.0f / 255.0f)
                                green:(51.0f / 255.0f)
                                blue:(51.0f / 255.0f)
                                alpha:1.0f];

//    if (indexPath.section == 0 && indexPath.row == 0)
//    {
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//        
//        UIImage *forwardImage = [UIImage imageNamed:@"Forward.png"];
//        cell.accessoryView = [[UIImageView alloc] initWithImage:forwardImage];
//        
//        UIImage *backgroundImage = [UIImage imageNamed:@"SettingCell1_1.png"];
//        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
//        cell.backgroundView = backgroundImageView;
//        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
//        {
//            cell.textLabel.backgroundColor = [UIColor clearColor];
//        }
//        else
//        {
//            cell.textLabel.backgroundColor = [UIColor whiteColor];
//        }
//        cell.textLabel.text = NSLocalizedString(@"Type", nil);
//        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
//        {
//            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
//        }
//        else
//        {
//            cell.detailTextLabel.backgroundColor = [UIColor whiteColor];
//        }
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
////        [switchView setOn:[userDefaults boolForKey:kEnabledAutomaticDownload] animated:NO];
//        NSArray *newsCategoryIdArray = [userDefaults objectForKey:kNewsCategoryType];
//        if ([newsCategoryIdArray count] == 0
//            || [newsCategoryIdArray count] == [_newsCategoryArray count])
//        {
//            cell.detailTextLabel.text = NSLocalizedString(@"All", nil);
//        }
//        else
//        {
//            NSMutableArray *newsCategoryNameArray = [[NSMutableArray alloc] init];
//            for (NSNumber *newsCategoryId in newsCategoryIdArray)
//            {
//                for (NewsCategory *newsCategory in _newsCategoryArray)
//                {
//                    if (newsCategoryId == newsCategory.newsCategoryId)
//                    {
//                        [newsCategoryNameArray addObject:newsCategory.title];
//                    }
//                }
//            }
//            cell.detailTextLabel.text = [newsCategoryNameArray componentsJoinedByString:@", "];
//        }
//    }
//    else
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        UISwitch *switchView = [[UISwitch alloc] init];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [switchView setOn:[userDefaults boolForKey:kEnabledNotification] animated:NO];
        cell.accessoryView = switchView;
        [switchView addTarget:self action:@selector(notificationsSwitchChanged:)
             forControlEvents:UIControlEventValueChanged];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if (appDelegate.deviceTokenString == nil)
        {
            switchView.enabled = NO;
        }
        
        UIImage *backgroundImage = [UIImage imageNamed:@"SettingCell2.png"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        cell.backgroundView = backgroundImageView;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        {
            cell.textLabel.backgroundColor = [UIColor clearColor];
        }
        else
        {
            cell.textLabel.backgroundColor = [UIColor whiteColor];
        }
        cell.textLabel.text = NSLocalizedString(@"Notifications", nil);
        
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [switchView setOn:[userDefaults boolForKey:kEnabledAutomaticDownload] animated:NO];
        [switchView addTarget:self action:@selector(wifiSwitchChanged:)
             forControlEvents:UIControlEventValueChanged];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIImage *backgroundImage = [UIImage imageNamed:@"SettingCell2.png"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        cell.backgroundView = backgroundImageView;
        
        cell.editing = false;

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        {
            cell.textLabel.backgroundColor = [UIColor clearColor];
        }
        else
        {
            cell.textLabel.backgroundColor = [UIColor whiteColor];
        }
        cell.textLabel.text = NSLocalizedString(@"Wi-Fi", nil);
    }
    else if (indexPath.section == 2 && indexPath.row == 0)
    {
        UIImage *forwardImage = [UIImage imageNamed:@"Forward.png"];
        cell.accessoryView = [[UIImageView alloc] initWithImage:forwardImage];
        
        UIImage *backgroundImage = [UIImage imageNamed:@"SettingCell2.png"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        cell.backgroundView = backgroundImageView;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        {
            cell.textLabel.backgroundColor = [UIColor clearColor];
        }
        else
        {
            cell.textLabel.backgroundColor = [UIColor whiteColor];
        }
        cell.textLabel.text = NSLocalizedString(@"About Us", nil);
        //        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else if (indexPath.section == 3 && indexPath.row == 0)
    {
        UIImage *backgroundImage = [UIImage imageNamed:@"SettingCell2.png"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        cell.backgroundView = backgroundImageView;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        {
            cell.textLabel.backgroundColor = [UIColor clearColor];

        }
        else
        {
            cell.textLabel.backgroundColor = [UIColor whiteColor];
        }
        cell.textLabel.text = NSLocalizedString(@"Clear the Cache", nil);
        //        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

- (void)notificationsSwitchChanged:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable)
    {
        UISwitch* switchView = sender;
        
        //    UIRemoteNotificationType mask = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        //    NSLog(@"mask %i", (mask & UIRemoteNotificationTypeAlert) == UIRemoteNotificationTypeAlert);'
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:switchView.on forKey:kEnabledNotification];
        
        ReceiveDevice *receiveDevice = [[ReceiveDevice alloc] initWithAttributes:appDelegate.deviceTokenString
                                                                     isSubscribe:switchView.on];
        [receiveDevice syncDeviceToken];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                            message:NSLocalizedString(@"Please connect to network.", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        
        UISwitch* switchView = sender;
        [switchView setOn:!switchView.on animated:YES];
    }
}

- (void)wifiSwitchChanged:(id)sender
{
    UISwitch* switchView = sender;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:switchView.on forKey:kEnabledAutomaticDownload];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && alertView.tag == kClearCacheAlertViewTag)
    {
        [self clearCache:nil];
    }
}

- (void)confirmClearCache:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"Confirm that you want to clear cache?", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:NSLocalizedString(@"Cancel", nil), nil];
    alertView.tag = kClearCacheAlertViewTag;
    [alertView show];
}

- (void)clearCache:(id)sender
{
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString* cacheDir = [paths objectAtIndex:0];
    NSDirectoryEnumerator* directoryEnumerator = [fileManager enumeratorAtPath:cacheDir];
    NSError* error = nil;
    BOOL isSuccess;
    
    NSString* file;
    while (file = [directoryEnumerator nextObject])
    {
        NSLog(@"path %@", [cacheDir stringByAppendingPathComponent:file]);
        isSuccess = [fileManager removeItemAtPath:[cacheDir stringByAppendingPathComponent:file] error:&error];
        if (!isSuccess && error)
        {
            NSLog(@"oops: %@", error);
        }
    }
    
//    if (error != nil)
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:[error localizedDescription]
//                                                           delegate:self
//                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    }
//    else
//    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"Cache has been successfully cleared.", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
//    }
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
    if (indexPath.section == 0 && indexPath.row == 0)
    {
//        [tableView deselectRowAtIndexPath:indexPath animated:NO];
//        NewsSettingViewController *newsSettingVC = [[NewsSettingViewController alloc] init];
//        newsSettingVC.dataObject = self.newsCategoryArray;
//        [self.navigationController pushViewController:newsSettingVC animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        AboutViewController *aboutVC = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    else if (indexPath.section == 3 && indexPath.row == 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self confirmClearCache:self];
    }
}

@end
