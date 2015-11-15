//
//  SidebarViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-9-5.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kSidebarCellHeight 45.0f

#import "SidebarViewController.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSArray *menuOptions;

@end

@implementation SidebarViewController

@synthesize selectSidebarDelegate;
@synthesize selectedIndex;

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
    // Options
    self.menuOptions = [NSArray arrayWithObjects:
                        [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Home", nil), @"title", @"Home.png", @"image", nil],
                        [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"News", nil), @"title", @"News.png", @"image", nil],
                        [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Magazine", nil), @"title", @"Issue.png", @"image", nil],
                        [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Settings", nil), @"title", @"Settings.png", @"image", nil],
                        nil];

    self.tableView.frame = self.view.bounds;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = kSidebarCellHeight;
    
    
    // Sidebar background
    UIImage *backgroundImageName = [UIImage imageNamed:@"Background.png"];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:backgroundImageName];
    self.tableView.userInteractionEnabled = YES;

    
    // Sidebar separator
    UIImage *sidebarSeparatorImage = [UIImage imageNamed:@"SidebarSeparator.png"];
    self.tableView.separatorColor = [UIColor colorWithPatternImage:sidebarSeparatorImage];
    
    
    // Fix IOS7 compatibility
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {

        
      //  self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.contentInset = UIEdgeInsetsMake(20.0,
                                                       self.tableView.contentInset.left,
                                                       self.tableView.contentInset.bottom,
                                                       self.tableView.contentInset.right);
    }
    
    
    // Sidebar table footer view
    self.tableView.tableFooterView = [[UIView alloc] init];
    CGRect tableFooterViewRect = CGRectMake(self.view.bounds.origin.x,
                                            self.tableView.rowHeight * [self.menuOptions count],
                                            self.view.bounds.size.width,
                                            self.view.bounds.size.height - self.tableView.rowHeight * [self.menuOptions count]);
    self.tableView.tableFooterView.frame = tableFooterViewRect;
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
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

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.backgroundView = [[UIView alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    
//    cell.backgroundView.backgroundColor = [UIColor blueColor];
    [cell.backgroundView setBackgroundColor:[UIColor
                                             colorWithRed:(31.0f / 255.0f)
                                             green:(31.0f / 255.0f)
                                             blue:(31.0f / 255.0f)
                                             alpha:1.0f]];
//
    UIImage *selectedBackgroundImage = [UIImage imageNamed:@"SidebarSelectedCell"];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedBackgroundImage];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    //    [cell.selectedBackgroundView setBackgroundColor:[UIColor blackColor]];
    
    NSDictionary *dict = [self.menuOptions objectAtIndex:indexPath.row];
    NSString *imageName = [dict valueForKey:@"image"];
    cell.imageView.image = [UIImage imageNamed:imageName];
    [cell.imageView setFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
    cell.textLabel.backgroundColor = [UIColor
                                     colorWithRed:(31.0f / 255.0f)
                                     green:(31.0f / 255.0f)
                                     blue:(31.0f / 255.0f)
                                     alpha:1.0f];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.textLabel.text = [dict valueForKey:@"title"];
    


    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [self.selectSidebarDelegate selectSidebarOption:indexPath.row];
}

@end
