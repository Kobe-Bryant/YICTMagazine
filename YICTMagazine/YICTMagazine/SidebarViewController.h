//
//  SidebarViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-9-5.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectSidebarDelegate.h"

@interface SidebarViewController : UITableViewController
{
    __unsafe_unretained id<SelectSidebarDelegate> selectSidebarDelegate;
}

@property (nonatomic, readwrite) NSUInteger selectedIndex;
@property (nonatomic, assign) id<SelectSidebarDelegate> selectSidebarDelegate;

@end
