//
//  NewsListViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-20.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarDelegate.h"
#import "YearScrollViewController.h"

@interface NewsListViewController : UITableViewController<YearScrollViewDelegate>

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) YearScrollViewController *yearScrollViewController;
@property (nonatomic, assign) id<SidebarDelegate> sidebarDelegate;
@property (nonatomic, retain) NSNumber *selectedYear;
@property (nonatomic, readwrite) NSUInteger offset;
@property (nonatomic, readwrite) NSUInteger limit;
@property (nonatomic, readwrite) BOOL isLoadingData;
@property (nonatomic, readwrite) BOOL isEnded;
@property (nonatomic, readwrite) BOOL isBacked;
@property (nonatomic, weak) NSError *currentError;
@property (nonatomic, readwrite) BOOL isDecelerating;
@property (nonatomic, readwrite) BOOL isShowingFilter;
@property (nonatomic, readwrite) dispatch_queue_t newsListImageQueue;

@end
