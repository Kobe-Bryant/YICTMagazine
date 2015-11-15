//
//  News.h
//  YICTMagazine
//
//  Created by Seven on 13-8-21.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsImage.h"
#import "Result.h"

@interface News : NSObject

@property (nonatomic, retain) NSNumber *newsId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *categoryName;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *contents;
@property (nonatomic, retain) NSString *coverImageUrlString;
@property (nonatomic, retain) NSString *thumbImageUrlString;
@property (nonatomic, retain) NSString *releaseDate;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, readwrite) NSUInteger updateTimeStamp;
@property (nonatomic, readwrite) BOOL hasUpdated;

- (id)initWithAttributes:(NSNumber*)newsId
                   title:(NSString*)title
            categoryName:(NSString*)categoryName
                 summary:(NSString*)summary
                contents:(NSString*)contents
     coverImageUrlString:(NSString*)coverImageUrlString
     thumbImageUrlString:(NSString*)thumbImageUrlString
             releaseDate:(NSString*)releaseDate
         updateTimeStamp:(NSUInteger)updateTimeStamp;

+ (Result*)getYearList;

+ (Result*)getList:(NSNumber*)year
isDisplayAtHomeView:(BOOL)isDisplayAtHomeView
newsCategoryIdArray:(NSArray*)newsCategoryIdArray
            offset:(NSUInteger)offset
             limit:(NSUInteger)limit;

+ (Result*)getDetail:(NSNumber*)newsId;

@end
