//
//  NewsCategoryDataAccess.m
//  YICTMagazine
//
//  Created by Seven on 13-8-30.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kDevice @"source"
#define kLanguage @"lang"
#define kStatus @"status"
#define kStatusCode @"code"
#define kList @"list"
#define kNewsCategoryId @"id"
#define kTitle @"title"

#import "NewsCategoryWebApiDataAccess.h"
#import "AppDelegate.h"
#import "WebApi.h"
#import "LanguageHelper.h"

@implementation NewsCategoryWebApiDataAccess

+ (Result*)getList
{
    Result *currentResult = [[Result alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone") forKey:kDevice];
    [params setObject:[LanguageHelper getCurrentLanguage] forKey:kLanguage];
    WebApi *api = [[WebApi alloc] initWithAttributes:@"getArticleCategoryList" params:params];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable)
    {
        // Get data
        Result *apiResult = [api getData];
        if (apiResult.isSuccess == NO)
        {
            return apiResult;
        }
        

        NSMutableArray *newsCategoryArray = [self getListByDictionary:apiResult.data];
        currentResult.isSuccess = YES;
        currentResult.data = newsCategoryArray;

        
        
        // Compare cache
        if (![api.returnData isEqualToData:[api getCacheFileData]])
        {
            currentResult.hasUpdated = YES;
            [api saveCacheData];
        }
    }
    else
    {
        // Get cache
        Result *cacheResult = [api getCacheFileDictionaryData];
        NSMutableArray *newsCategoryArray = nil;
        if (cacheResult.isSuccess)
        {
            newsCategoryArray = [self getListByDictionary:cacheResult.data];
            currentResult.isSuccess = YES;
            currentResult.data = newsCategoryArray;
        }
        else
        {
            currentResult.isSuccess = NO;
            currentResult.error = cacheResult.error;
        }
    }
    
    return currentResult;
}

+ (NSMutableArray*)getListByDictionary:(NSDictionary*)dict
{
    NSMutableArray *newsCategoryArray = nil;
    if (dict != nil)
    {
        NSDictionary *status = [dict objectForKey:kStatus];
        NSInteger statusCode = [[status objectForKey:kStatusCode] integerValue];
        if (statusCode == 1)
        {
            newsCategoryArray = [[NSMutableArray alloc] init];
            NSDictionary *list = [dict objectForKey:kList];
            for (NSDictionary *info in list)
            {
                NSNumber *newsCategoryId = [NSNumber numberWithInteger:[[info objectForKey:kNewsCategoryId] integerValue]];
                NewsCategory *newsCategory = [[NewsCategory alloc]
                                              initWithAttributes:newsCategoryId
                                              title:[info objectForKey:kTitle]];
                [newsCategoryArray addObject:newsCategory];
            }
        }
    }
    
    return newsCategoryArray;
}

@end
