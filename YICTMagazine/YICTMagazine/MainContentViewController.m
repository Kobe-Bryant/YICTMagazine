//
//  MainContentViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-26.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "MainContentViewController.h"
#import "HomeViewController.h"
#import "NewsListViewController.h"

@interface MainContentViewController ()

@end

@implementation MainContentViewController

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
	// Do any additional setup after loading the view.
    // Title
    self.title = @"YICT";
    


    // Home view
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    [self.view addSubview:homeVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleSidebar:(id)sender
{
    NewsListViewController *newsListVC = [[NewsListViewController alloc] init];
    [self.navigationController pushViewController:newsListVC animated:YES];
//    NSLog(@"%@", sender);
}

@end
