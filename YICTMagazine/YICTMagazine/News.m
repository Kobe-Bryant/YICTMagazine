//
//  News.m
//  YICTMagazine
//
//  Created by Seven on 13-8-21.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "News.h"
#import "NewsWebApiDataAccess.h"
#import "AppDelegate.h"

@implementation News

- (id)initWithAttributes:(NSNumber *)newsId
                   title:(NSString *)title
            categoryName:(NSString *)categoryName
                 summary:(NSString *)summary
                contents:(NSString *)contents
     coverImageUrlString:(NSString *)coverImageUrlString
     thumbImageUrlString:(NSString *)thumbImageUrlString
             releaseDate:(NSString *)releaseDate
         updateTimeStamp:(NSUInteger)updateTimeStamp{
    _newsId = newsId;
    _title = title;
    _categoryName = categoryName;
    _summary = summary;
    _contents = contents;
    _coverImageUrlString = coverImageUrlString;
    _thumbImageUrlString = thumbImageUrlString;
    _releaseDate = releaseDate;
    _updateTimeStamp = updateTimeStamp;
    return self;
}

/*
- (id)releaseDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *identifier = [[NSLocale currentLocale] localeIdentifier];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:identifier];
    [dateFormatter setLocale:locale];
    return [dateFormatter stringFromDate:self.releaseDate];
}
*/

+ (Result*)getYearList
{
    return [NewsWebApiDataAccess getYearList];
}

+ (Result*)getList:(NSNumber*)year
isDisplayAtHomeView:(BOOL)isDisplayAtHomeView
newsCategoryIdArray:(NSArray*)newsCategoryIdArray
            offset:(NSUInteger)offset
             limit:(NSUInteger)limit
{
    return [NewsWebApiDataAccess getList:year
                     isDisplayAtHomeView:isDisplayAtHomeView
                     newsCategoryIdArray:newsCategoryIdArray
                                  offset:offset
                                   limit:limit];
}

+ (Result*)getDetail:(NSNumber*)newsId
{
    return [NewsWebApiDataAccess getDetail:newsId];
}

@end
