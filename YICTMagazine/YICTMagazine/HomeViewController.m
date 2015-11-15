//
//  HomeViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-17.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kMagazineContainerHeight 155.0f

#import "HomeViewController.h"
#import "News.h"
#import "NewsDetailsViewController.h"
#import "Magazine.h"
//#import "MagazineDetailsViewController.h"
#import "MagazineTabBarViewController.h"
#import "AppDelegate.h"
#import "AlertView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize sidebarDelegate;
@synthesize newsBannerSVC;
@synthesize magazineBannerSVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Title
    self.title = NSLocalizedString(@"YICT Updates", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];

    

    
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
    

    // Banner
    float height = [[UIScreen mainScreen] bounds].size.height - kMagazineContainerHeight - 64.0f;
    CGRect newsRect = CGRectMake(0.0f,
                                 0.0f,
                                 self.view.frame.size.width,
                                 height);
    Result *newsArrayResult = [News getList:@-1 isDisplayAtHomeView:YES newsCategoryIdArray:nil offset:0 limit:5];
    if (newsArrayResult.isSuccess && newsArrayResult.data != nil)
    {
        _newsArray = newsArrayResult.data;
    }
    self.newsBannerSVC = [[HomeNewsScrollViewController alloc] initWithFrame:newsRect
                                                                  dataObject:_newsArray];
    self.newsBannerSVC._delegate = self;
    [self.view addSubview:self.newsBannerSVC.view];
    

    // Magazine
    CGRect magazineRect = CGRectMake(0.0f,
                                     self.newsBannerSVC.view.frame.size.height,
                                     self.view.frame.size.width,
                                     kMagazineContainerHeight);
    Result *magazineArrayResult = [Magazine getList:YES isNew:NO offset:0 limit:6];
    if (magazineArrayResult.isSuccess && magazineArrayResult.data != nil)
    {
        _magazineArray = magazineArrayResult.data;
    }
    self.magazineBannerSVC = [[HomeMagazineScrollViewController alloc] initWithFrame:magazineRect
                                                                          dataObject:_magazineArray];
    self.magazineBannerSVC.delegate = self;
    [self.view addSubview:self.magazineBannerSVC.view];

}

- (void)viewWillAppear:(BOOL)animated
{
    // Reset frame
    float height = [[UIScreen mainScreen] bounds].size.height - kMagazineContainerHeight - 64.0f;
    self.newsBannerSVC.view.frame = CGRectMake(0.0f,
                                               0.0f,
                                               self.view.frame.size.width,
                                               height);

    self.magazineBannerSVC.view.frame = CGRectMake(0.f,
                                                   self.newsBannerSVC.view.frame.size.height,
                                                   self.view.frame.size.width,
                                                   kMagazineContainerHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _newsArray = nil;
    _magazineArray = nil;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)toggleSidebar:(id)sender
{
    [self.sidebarDelegate toggleSidebrButtonPressed:self];
}

- (void)newsViewPressed:(id)sender
{
    NewsDetailsViewController *controller = [[NewsDetailsViewController alloc] init];
    controller.dataObject = sender;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)magazineViewPressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable
        && appDelegate.wifiReachability.currentReachabilityStatus == NotReachable)
    {
        AlertView *alertView = [[AlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                        message:NSLocalizedString(@"You did not use Wi-Fi connection. Are you sure you want to continue connecting?", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"View", nil)
                                              otherButtonTitles:NSLocalizedString(@"Cancel", nil), nil];
        alertView.dataObject = sender;
        [alertView show];
    }
    else
    {
        MagazineTabBarViewController *controller = [[MagazineTabBarViewController alloc] initWithDataObject:sender];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        MagazineTabBarViewController *controller = [[MagazineTabBarViewController alloc] initWithDataObject:alertView.dataObject];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
