//
//  MagazineImageTitleViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-26.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "MagazineImageTitleViewController.h"
#import "MagazineCatalog.h"
#import "MagazineTabBarViewController.h"

@interface MagazineImageTitleViewController ()

@end

@implementation MagazineImageTitleViewController

@synthesize magazineTabBarSwitchDelegate;
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
    // Bind data
    _magazine = dataObject;
    _magazineCatalogArray = _magazine.catalogs;
    _magazineImageArray = _magazine.images;
    
    for (MagazineCatalog *magazineCatalog in self.magazineImageArray)
    {
//        NSLog(@"magazineCatalog.title %@", magazineCatalog.title);
    }
    
    
    // Fix IOS7 compatibility
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        _statusBarBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                                            -20.0,
                                                                            self.view.frame.size.width,
                                                                            20.0)];
        _statusBarBackgroundView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_statusBarBackgroundView];
        
        self.tableView.contentInset = UIEdgeInsetsMake(20.0,
                                                       self.tableView.contentInset.left,
                                                       self.tableView.contentInset.bottom,
                                                       self.tableView.contentInset.right);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([_magazineCatalogArray count] == 0)
    {
        // Tips
        UIView *tipsView = [[UIView alloc] init];
        tipsView.frame = CGRectMake((self.view.bounds.size.width - 240.0) / 2.0,
                                    (self.view.bounds.size.height - 100.0) / 2.0,
                                    240.0,
                                    100.0);
        tipsView.backgroundColor = [UIColor blackColor];
    
      //  tipsView.layer.masksToBounds = YES;

     //   tipsView.layer.cornerRadius = 10.0;
        tipsView.alpha = 0.8;
        [self.view addSubview:tipsView];
        
        
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.frame = CGRectMake(20.0, 20.0, 200.0, 60.0);
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        tipsLabel.numberOfLines = 2;
        tipsLabel.text = NSLocalizedString(@"Catalog content is empty", nil);
        [tipsView addSubview:tipsLabel];
    }
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
    return [_magazineCatalogArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    MagazineCatalog *magazineCatalog = [_magazineCatalogArray objectAtIndex:indexPath.row];
    cell.textLabel.text = magazineCatalog.title;
    
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
    NSIndexPath *imageIndexPath = [self indexPathAtGallery:indexPath];
    if (imageIndexPath != nil)
    {
        [self.magazineTabBarSwitchDelegate setMagazineGallerySelectedIndex:imageIndexPath.row];
        [self.magazineTabBarSwitchDelegate tabBarSwitchButtonPress:self];
    }
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Fix IOS7 compatibility
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        _statusBarBackgroundView.frame = CGRectMake(0.0,
                                                    scrollView.contentOffset.y,
                                                    self.view.frame.size.width,
                                                    20.0);
    }
}

- (NSIndexPath *)indexPathAtGallery:(NSIndexPath *)indexPath
{
    MagazineCatalog *magazineCatalog = [_magazineCatalogArray objectAtIndex:indexPath.row];
    for (NSInteger i = 0; i < [_magazineImageArray count]; i++)
    {
        MagazineImage *magazineImage = [_magazineImageArray objectAtIndex:i];
        if ([magazineImage.magazineImageId isEqualToNumber:magazineCatalog.magazineImageId])
        {
            return [NSIndexPath indexPathForRow:i inSection:0];
        }
    }

    return nil;
}

@end
