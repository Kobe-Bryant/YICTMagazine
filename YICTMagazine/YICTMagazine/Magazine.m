//
//  Magazine.m
//  YICTMagazine
//
//  Created by Seven on 13-8-21.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "Magazine.h"
#import "MagazineWebApiDataAccess.h"
#import "AppDelegate.h"

@implementation Magazine

- (id)initWithAttributes:(NSNumber *)magazineId
                   title:(NSString *)title
     coverImageUrlString:(NSString *)coverImageUrlString
         updateTimeStamp:(NSUInteger)updateTimeStamp
{
    _magazineId = magazineId;
    _title = title;
    _coverImageUrlString = coverImageUrlString;
    _updateTimeStamp = updateTimeStamp;
    return self;
}

+ (Result*)getList:(BOOL)isDisplayAtHomeView
             isNew:(BOOL)isNew
            offset:(NSUInteger)offset
             limit:(NSUInteger)limit
{
    return [MagazineWebApiDataAccess getList:isDisplayAtHomeView
                                       isNew:isNew
                                      offset:offset
                                       limit:limit];
}

+ (Result*)getDetail:(NSNumber*)magazineId
{
    return [MagazineWebApiDataAccess getDetail:magazineId];
}

- (void)refreshDownloadStatus
{
    if ([MagazineWebApiDataAccess refreshDownloadStatus:self])
    {
        self.hasDownloaded = YES;
    }
}

@end
