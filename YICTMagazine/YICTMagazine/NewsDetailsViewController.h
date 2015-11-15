//
//  NewsDetailsViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-20.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsBannerScrollViewController.h"
#import "News.h"

@interface NewsDetailsViewController : UIViewController<UIScrollViewDelegate, NewsBannerScrollViewDelegate, UIWebViewDelegate>
{
    NewsBannerScrollViewController *newsBannerScrollViewController;
}

@property (nonatomic, retain) id dataObject;
@property (nonatomic, retain) News *news;
@property (nonatomic, readwrite) NSUInteger selectedIndex;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, weak) NSError *currentError;

@end
