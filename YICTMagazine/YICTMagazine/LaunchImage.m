//
//  LaunchImage.m
//  YICTMagazine
//
//  Created by Seven on 13-9-3.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kCacheImageBasePath @""
#import "LaunchImage.h"
#import "LaunchImageWebApiDataAccess.h"
#import "AppDelegate.h"

@implementation LaunchImage

- (id)initWithAttributes:(NSString*)imageUrlString
           isLeftToRight:(BOOL)isLeftToRight
         updateTimeStamp:(NSUInteger)updateTimeStamp
{
    _imageUrlString = imageUrlString;
    _isLeftToRight = isLeftToRight;
    _updateTimeStamp = updateTimeStamp;
    return self;
}

+ (Result*)getInfo
{
    return [LaunchImageWebApiDataAccess getInfo];
}

@end
