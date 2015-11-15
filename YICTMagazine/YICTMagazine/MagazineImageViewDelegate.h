//
//  MagazineImageViewDelegate.h
//  YICTMagazine
//
//  Created by Seven on 13-9-6.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MagazineImageViewDelegate <NSObject>

- (void)turnPrevious;
- (void)turnNext;

@end
