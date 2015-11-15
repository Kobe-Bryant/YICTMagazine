//
//  MagazineThumbImageViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-25.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineTabBarSwitchDelegate.h"

@interface MagazineThumbImageViewController : UIViewController
{
    __unsafe_unretained id<MagazineTabBarSwitchDelegate> magazineTabBarSwitchDelegate;
}

@property (nonatomic, assign) id<MagazineTabBarSwitchDelegate> magazineTabBarSwitchDelegate;
@property (nonatomic, retain) id dataObject;
@property (nonatomic, retain) UIScrollView *scrollView;

@end
