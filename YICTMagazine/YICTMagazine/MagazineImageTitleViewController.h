//
//  MagazineImageTitleViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-26.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineTabBarSwitchDelegate.h"
#import "Magazine.h"

@interface MagazineImageTitleViewController : UITableViewController

@property (nonatomic, assign) id<MagazineTabBarSwitchDelegate> magazineTabBarSwitchDelegate;
@property (nonatomic, retain) id dataObject;
@property (nonatomic, retain) Magazine *magazine;
@property (nonatomic, retain) NSMutableArray *magazineCatalogArray;
@property (nonatomic, retain) NSMutableArray *magazineImageArray;
@property (nonatomic, retain) UIView *statusBarBackgroundView;

@end
