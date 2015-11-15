//
//  NewsGalleryViewController.h
//  YICTMagazine
//
//  Created by Seven on 13-8-21.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsGalleryImageScrollViewController.h"

@interface NewsGalleryViewController : UIViewController

@property (nonatomic, retain) id dataObject;
@property (nonatomic, readwrite) NSUInteger selectedIndex;
@property (nonatomic, retain) NewsGalleryImageScrollViewController *newsGalleryImageSVC;
@property (nonatomic, readwrite) UIDeviceOrientation deviceOrientation;


@end
