//
//  NewsGalleryImageScrollViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-21.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsGalleryImageScrollViewController : UIViewController<UIScrollViewDelegate>
{
    CGRect _rect;
	id _dataObject;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, readwrite) NSUInteger selectedIndex;

- (id)initWithFrame:(CGRect)rect dataObject:(NSArray *)dataObject selectedIndex:(NSUInteger)selectedIndex;
- (void)reloadView;

@end
