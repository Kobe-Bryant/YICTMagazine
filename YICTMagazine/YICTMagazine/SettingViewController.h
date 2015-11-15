//
//  SettingViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-19.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarDelegate.h"

@interface SettingViewController : UITableViewController
{
    __unsafe_unretained id<SidebarDelegate> sidebarDelegate;
}

@property (nonatomic, assign) id<SidebarDelegate> sidebarDelegate;

@end
