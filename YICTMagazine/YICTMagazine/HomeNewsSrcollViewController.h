//
//  HomeNewsScollViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-30.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNewsScrollViewDelegate.h"

@interface HomeNewsScrollViewController : UIViewController<UIScrollViewDelegate>
{
    __unsafe_unretained id<HomeNewsScrollViewDelegate> _delegate;
	CGRect _rect;
	UIScrollView *_scrollView;
	UIPageControl *_pageControl;
    id _dataObject;
}

@property (nonatomic, assign) id<HomeNewsScrollViewDelegate> _delegate;

- (id)initWithFrame:(CGRect)rect dataObject:(NSArray *)dataObject;

@end
