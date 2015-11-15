//
//  MagazineZoomImageViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-23.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "TapDetectingImageView.h"
#import "MagazineImageViewDelegate.h"

@interface MagazineImageViewController : UIViewController<UIScrollViewDelegate, TapDetectingImageViewDelegate>

@property (nonatomic, assign) id<MagazineImageViewDelegate> magazineImageViewDelegate;
@property (nonatomic, readwrite) CGRect frameRect;
@property (readwrite, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UILabel *screenNumber;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, readwrite) NSInteger viewCount;
@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) UIImageView *pagerView;
@property (strong, nonatomic) UILabel *pagerTextLabel;
@property (nonatomic, retain) TapDetectingImageView *imageView;
@property (nonatomic, readwrite) float minimumScale;
@property (nonatomic, readwrite) BOOL isZoomIn;
@property (nonatomic, readwrite) NSInteger zoomTimes;
@property (nonatomic, readwrite) BOOL isTapAction;

- (id)initWithFrame:(CGRect)rect;

- (id)initWithFrame:(CGRect)rect dataObject:(id)_dataObject index:(NSInteger)_index viewCount:(NSInteger)_viewCount;

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end
