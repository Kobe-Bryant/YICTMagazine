//
//  MagazineGalleryViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-22.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineImageViewController.h"

@interface MagazineGalleryViewController : UIViewController<UIPageViewControllerDataSource, UIGestureRecognizerDelegate, MagazineImageViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) id dataObject;

- (MagazineImageViewController *)viewControllerAtIndex:(NSInteger)index;
- (void)turnPrevious;
- (void)turnNext;

@end
