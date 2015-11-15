//
//  NavigationController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-15.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

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
    // Navigation bar color
    [self.navigationBar setTintColor:[UIColor blackColor]];
    NSString *backgroundImageName = [NSString stringWithFormat:@"BlackPoint.png"];
    UIImage *backgroundImage = [UIImage imageNamed:backgroundImageName];
    [self.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
