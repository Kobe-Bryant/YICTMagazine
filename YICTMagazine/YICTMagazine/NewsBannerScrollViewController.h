//
//  ImageScrollViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-15.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsBannerScrollViewDelegate.h"

@interface NewsBannerScrollViewController : UIViewController<UIScrollViewDelegate>
{
    __unsafe_unretained id<NewsBannerScrollViewDelegate> delegate;
	CGRect _rect;
	UIScrollView *_scrollView;
	UIPageControl *_pageControl;
    id _dataObject;
}

@property (nonatomic, assign) id<NewsBannerScrollViewDelegate> delegate;

- (id)initWithFrame:(CGRect)rect dataObject:(NSArray *)dataObject;

@end
