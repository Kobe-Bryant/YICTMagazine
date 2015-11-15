//
//  HomeViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-17.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarDelegate.h"
#import "HomeNewsSrcollViewController.h"
#import "HomeMagazineScrollViewController.h"

@interface HomeViewController : UIViewController<HomeNewsScrollViewDelegate, HomeMagazineScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) id<SidebarDelegate> sidebarDelegate;
@property (nonatomic, strong) HomeNewsScrollViewController *newsBannerSVC;
@property (nonatomic, strong) HomeMagazineScrollViewController *magazineBannerSVC;
@property (nonatomic, retain) NSArray *newsArray;
@property (nonatomic, retain) NSArray *magazineArray;


@end
