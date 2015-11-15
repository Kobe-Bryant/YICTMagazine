//
//  RootViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-15.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kSidebarWidth 215.0f
#import "RootViewController.h"
#import "NavigationController.h"
#import "NewsListViewController.h"
#import "MagazineListViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"

@interface RootViewController ()

@property (nonatomic, strong) NSArray *menuOptions;

@end

@implementation RootViewController

@synthesize homeVC, mainContentVC, sidebarVC, emptySpaceVC, sidebarSelectedIndex, welcomeVC;

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

    
    self.sidebarVC = [[SidebarViewController alloc] init];
    self.sidebarVC.view.frame = CGRectMake(0.0f,
                                           0.0f,
                                           kSidebarWidth,
                                           self.view.bounds.size.height);
    self.sidebarVC.selectSidebarDelegate = self;
    [self.view addSubview:self.sidebarVC.view];
    self.sidebarSelectedIndex = 0;
    
    
   
    // Main content
    self.homeVC  = [[HomeViewController alloc] init];
    self.homeVC.sidebarDelegate = self;
    self.mainContentVC = [[NavigationController alloc] initWithRootViewController:homeVC];
    self.mainContentVC.view.frame = self.view.bounds;
    [self.view addSubview:self.mainContentVC.view];
 
    
    // Empty space
    
  
    self.emptySpaceVC = [[UIViewController alloc] init];
    self.emptySpaceVC.view.frame = CGRectMake(kSidebarWidth,
                                              0.0f,
                                              self.view.bounds.size.width - self.sidebarVC.view.bounds.size.width,
                                              self.view.bounds.size.height);
   
    UIButton *toggleContentViewButton = [[UIButton alloc] init];
    toggleContentViewButton.frame = self.emptySpaceVC.view.bounds;
    toggleContentViewButton.backgroundColor = [UIColor clearColor];
    toggleContentViewButton.alpha = 0.1f;
    [toggleContentViewButton addTarget:self action:@selector(toggleSidebrButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    toggleContentViewButton.userInteractionEnabled = YES;
    [self.emptySpaceVC.view addSubview:toggleContentViewButton];
    
    [self.view addSubview:self.emptySpaceVC.view];
    self.emptySpaceVC.view.hidden = YES;
     
   
    
    
    // Welcome view
    self.welcomeVC = [[WelcomeViewController alloc] init];
    self.welcomeVC.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.welcomeVC.view.userInteractionEnabled = YES;
    [self.view addSubview:self.welcomeVC.view];
    
    
    
    // Check the network connection
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                            message:NSLocalizedString(@"You are currently in offline model.", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)toggleSidebrButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.25f animations:^{
        CGRect mainContentRect = self.mainContentVC.view.frame;
        if (mainContentRect.origin.x != 0)
        {
            mainContentRect.origin.x -= kSidebarWidth;
        }
        else
        {
            mainContentRect.origin.x += kSidebarWidth;
        }
        self.mainContentVC.view.frame = mainContentRect;
        self.emptySpaceVC.view.hidden = !self.emptySpaceVC.view.hidden;
     } completion:nil];
}

- (void)selectSidebarOption:(NSUInteger)selectedIndex
{
    // Hide sidebar
    [self toggleSidebrButtonPressed:self];
    
    // Go to
    if (self.sidebarSelectedIndex != selectedIndex)
    {
        self.sidebarSelectedIndex = selectedIndex;
        if (selectedIndex == 1)
        {
            NewsListViewController *newsListVC = [[NewsListViewController alloc] init];
            newsListVC.sidebarDelegate = self;
            [self.homeVC.navigationController pushViewController:newsListVC animated:NO];
        }
        else if (selectedIndex == 2)
        {
          
            MagazineListViewController *magazineListVC = [[MagazineListViewController alloc] init];
            magazineListVC.sidebarDelegate = self;
            [self.homeVC.navigationController pushViewController:magazineListVC animated:NO];
        }
        else if (selectedIndex == 3)
        {
            SettingViewController *settingVC = [[SettingViewController alloc] init];
            settingVC.sidebarDelegate = self;
            [self.homeVC.navigationController pushViewController:settingVC animated:NO];
        }
        else
        {
            HomeViewController *_homeVC = [[HomeViewController alloc] init];
            _homeVC.sidebarDelegate = self;
            [self.homeVC.navigationController pushViewController:_homeVC animated:NO];
        }
    }
}

@end
