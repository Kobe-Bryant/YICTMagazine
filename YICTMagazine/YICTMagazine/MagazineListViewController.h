//
//  MagazineListViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-21.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarDelegate.h"

@interface MagazineListViewController : UIViewController<UIScrollViewDelegate, UIAlertViewDelegate>
{
    __unsafe_unretained id<SidebarDelegate> sidebarDelegate;
}

@property (nonatomic, assign) id<SidebarDelegate> sidebarDelegate;
@property (nonatomic, retain) NSMutableArray *magazineArray;
@property (nonatomic, readwrite) NSUInteger offset;
@property (nonatomic, readwrite) NSUInteger limit;
@property (nonatomic, readwrite) BOOL isLoadingData;
@property (nonatomic, readwrite) BOOL isEnded;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIActivityIndicatorView *loadingAIV;
@property (nonatomic, weak) NSError *currentError;
@property (nonatomic, readwrite) BOOL isResized;

@end
