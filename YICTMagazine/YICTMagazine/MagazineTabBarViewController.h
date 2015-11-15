//
//  MagazineTabBarViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-23.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineGalleryViewController.h"
#import "MagazineTabBarSwitchDelegate.h"
#import "Magazine.h"

@interface MagazineTabBarViewController : UITabBarController<UITabBarControllerDelegate, MagazineTabBarSwitchDelegate>

@property (nonatomic, strong) MagazineGalleryViewController *magazineGalleryVC;
@property (nonatomic, retain) id dataObject;
@property (nonatomic, retain) Magazine *magazine;
@property (nonatomic, weak) NSError *currentError;

- (id)initWithDataObject:(id)_dataObject;
- (void)reloadTabBar;

@end
