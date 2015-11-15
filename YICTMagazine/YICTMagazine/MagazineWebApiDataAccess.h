//
//  MagazineWebApiDataAccess.h
//  YICTMagazine
//
//  Created by Seven on 13-9-2.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Magazine.h"

@interface MagazineWebApiDataAccess : NSObject

+ (Result*)getList:(BOOL)isDisplayAtHomeView
             isNew:(BOOL)isNew
            offset:(NSUInteger)offset
             limit:(NSUInteger)limit;

+ (Result*)getDetail:(NSNumber*)magazineId;

+ (BOOL)refreshDownloadStatus:(Magazine*)magazine;

@end
