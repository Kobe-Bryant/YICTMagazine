//
//  WelcomeViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-9-6.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchImage.h"

@interface WelcomeViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *sceneView;
//@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIImageView *upImageView;
@property (nonatomic, retain) LaunchImage *launchImage;
@property (nonatomic, readwrite) BOOL isDragDown;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *logoBackgroundImageView;

@end
