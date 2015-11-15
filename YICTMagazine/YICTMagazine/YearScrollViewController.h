//
//  YearScrollViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-20.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YearScrollViewDelegate.h"

@interface YearScrollViewController : UIViewController<UIScrollViewDelegate>
{
	CGRect _rect;
    int _columnWidth;
	UIScrollView *_scrollView;
	NSMutableArray *_yearArray;
}

@property (nonatomic, assign) id<YearScrollViewDelegate> yearDelegate;
@property (nonatomic, retain) NSNumber *_selectedYear;
@property (nonatomic, readwrite) BOOL isDecelerating;

- (id)initWithFrame:(CGRect)rect ColumnWidth:(int)columnWidth YearArray:(NSArray *)yearArray SelectedYear:(NSNumber *)selectedYear;

@end
