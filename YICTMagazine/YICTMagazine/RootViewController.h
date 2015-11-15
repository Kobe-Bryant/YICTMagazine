//
//  RootViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-15.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarDelegate.h"
#import "SidebarViewController.h"
#import "HomeViewController.h"
#import "WelcomeViewController.h"

@interface RootViewController : UIViewController<SidebarDelegate, SelectSidebarDelegate>

@property (nonatomic, retain) HomeViewController *homeVC;
@property (nonatomic, strong) UIViewController *mainContentVC;
@property (nonatomic, strong) SidebarViewController *sidebarVC;
@property (nonatomic, strong) UIViewController *emptySpaceVC;
@property (nonatomic, readwrite) NSUInteger sidebarSelectedIndex;
@property (nonatomic, retain) WelcomeViewController *welcomeVC;

@end
