//
//  HomeMagazineScrollViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-9-4.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeMagazineScrollViewDelegate.h"

@interface HomeMagazineScrollViewController : UIViewController<UIScrollViewDelegate>
{
    __unsafe_unretained id<HomeMagazineScrollViewDelegate> delegate;
	CGRect _rect;
	UIScrollView *_scrollView;
	UIPageControl *_pageControl;
    id _dataObject;
}

@property (nonatomic, assign) id<HomeMagazineScrollViewDelegate> delegate;

- (id)initWithFrame:(CGRect)rect dataObject:(NSArray *)dataObject;

@end
