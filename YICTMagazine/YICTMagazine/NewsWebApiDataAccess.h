//
//  NewsDataAccess.h
//  YICTMagazine
//
//  Created by Seven on 13-8-30.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "News.h"

@interface NewsWebApiDataAccess : NSObject

+ (Result*)getYearList;

+ (Result*)getList:(NSNumber*)year
isDisplayAtHomeView:(BOOL)isDisplayAtHomeView
newsCategoryIdArray:(NSArray*)newsCategoryIdArray
            offset:(NSUInteger)offset
             limit:(NSUInteger)limit;

+ (Result*)getDetail:(NSNumber*)newsId;

@end
