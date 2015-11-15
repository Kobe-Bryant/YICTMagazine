//
//  NewsCategory.m
//  YICTMagazine
//
//  Created by Seven on 13-8-30.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "NewsCategory.h"
#import "NewsCategoryWebApiDataAccess.h"

@implementation NewsCategory

- (id)initWithAttributes:(NSNumber*)newsCategoryId title:(NSString*)title
{
    _newsCategoryId = newsCategoryId;
    _title = title;
    return self;
}

+ (Result*)getList
{
    return [NewsCategoryWebApiDataAccess getList];
}

@end
