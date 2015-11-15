//
//  MagazineTabBarSwitchDelegate.h
//  YICTMagazine
//
//  Created by Seven on 13-8-30.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MagazineTabBarSwitchDelegate <NSObject>

- (void)setMagazineGallerySelectedIndex:(NSInteger)index;
- (void)tabBarSwitchButtonPress:(id)sender;

@end
