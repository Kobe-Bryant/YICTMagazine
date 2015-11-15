//
//  NewsDataAccess.m
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
#define kDetail @"Detail"
#define kYear @"year"
#define kIsDisplayAtHomeView @"isIndex"
#define kNewsCategoryIds @"categoryIds"
#define kOffset @"offsetStart"
#define kLimit @"maxPageItems"
#define kNewsId @"id"
#define kTitle @"title"
#define kCategoryName @"categoryName"
#define kSummary @"summary"
#define k3InchCoverImageUrlString @"indexPhotoSmall"
#define k3Dot5InchCoverImageUrlString @"indexPhotoMedium"
#define k3InchThumbImageUrlString @"photoSmall"
#define k3Dot5InchThumbImageUrlString @"photoMedium"
#define kReleaseDate @"postTime"
#define kContent @"content"
#define kGallery @"galleryList"
#define kNewsImageId @"id"
#define k3InchGalleryImageUrlString @"smallPhoto"
#define k3Dot5InchGalleryImageUrlString @"photo"
#define kUpdateTimeStamp @"updateTime"

#import "NewsWebApiDataAccess.h"
#import "AppDelegate.h"
#import "WebApi.h"
#import "LanguageHelper.h"

@implementation NewsWebApiDataAccess

+ (Result*)getYearList
{
    Result *currentResult = [[Result alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone") forKey:kDevice];
    [params setObject:[[NSLocale currentLocale] localeIdentifier] forKey:kLanguage];
    [params setObject:[LanguageHelper getCurrentLanguage] forKey:kLanguage];
    WebApi *api = [[WebApi alloc] initWithAttributes:@"getArticleYearList" params:params];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable)
    {
        // Get data
        Result *apiResult = [api getData];
        if (apiResult.isSuccess == NO)
        {
            return apiResult;
        }

        NSMutableArray *yearArray = [self getYearListByDictionary:apiResult.data];
        currentResult.isSuccess = YES;
        currentResult.data = yearArray;
        
        
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
        NSMutableArray *yearArray = nil;
        if (cacheResult.isSuccess)
        {
            yearArray = [self getYearListByDictionary:cacheResult.data];
            currentResult.isSuccess = YES;
            currentResult.data = yearArray;
        }
        else
        {
            currentResult.isSuccess = NO;
            currentResult.error = cacheResult.error;
        }
    }

    return currentResult;
}

+ (NSMutableArray*)getYearListByDictionary:(NSDictionary*)dict
{
    NSMutableArray *yearArray = [[NSMutableArray alloc] init];
    if (dict != nil)
    {
        NSDictionary *status = [dict objectForKey:kStatus];
        NSInteger statusCode = [[status objectForKey:kStatusCode] integerValue];
        if (statusCode == 1)
        {
            NSDictionary *list = [dict objectForKey:kList];
            for (NSDictionary *info in list)
            {
                NSNumber *year = [NSNumber numberWithInteger:[[info objectForKey:kYear] integerValue]];
                if ([yearArray indexOfObject:year] == NSNotFound)
                {
                    [yearArray addObject:year];
                }
            }
        }
    }
    return yearArray;
}

+ (Result*)getList:(NSNumber*)year
isDisplayAtHomeView:(BOOL)isDisplayAtHomeView
newsCategoryIdArray:(NSArray*)newsCategoryIdArray
            offset:(NSUInteger)offset
             limit:(NSUInteger)limit
{
    Result *currentResult = [[Result alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone") forKey:kDevice];
    [params setObject:[LanguageHelper getCurrentLanguage] forKey:kLanguage];
    [params setObject:[year stringValue] forKey:kYear];
    [params setObject:(isDisplayAtHomeView ? @"1" : @"0") forKey:kIsDisplayAtHomeView];
    if ([newsCategoryIdArray count] > 0)
    {
        [params setObject:[newsCategoryIdArray componentsJoinedByString:@","]
                   forKey:kNewsCategoryIds];
    }
    else
    {
        [params setObject:@"" forKey:kNewsCategoryIds];
    }
    [params setObject:[[NSString alloc] initWithFormat:@"%i", offset] forKey:kOffset];
    [params setObject:[[NSString alloc] initWithFormat:@"%i", limit] forKey:kLimit];
    WebApi *api = [[WebApi alloc] initWithAttributes:@"getArticleList" params:params];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable)
    {
        // Get data
        Result *apiResult = [api getData];
        if (apiResult.isSuccess == NO)
        {
            return apiResult;
        }
        
        NSMutableArray *newsArray = [self getListByDictionary:apiResult.data];
        currentResult.isSuccess = YES;
        currentResult.data = newsArray;


        // Compare data
        Result *cacheResult = [api getCacheFileDictionaryData];
        if (cacheResult.isSuccess)
        {
            NSMutableArray *cacheNewsArray = [self getListByDictionary:cacheResult.data];
            for (int i = 0; i < [newsArray count]; i ++)
            {
                News *news = [newsArray objectAtIndex:i];
                BOOL isExisted = NO;
                for (News *cacheNews in cacheNewsArray)
                {
                    if ([news.newsId isEqualToNumber:cacheNews.newsId])
                    {
                        isExisted = YES;
                    }
                }
                if (isExisted == NO)
                {
                    news.hasUpdated = YES;
                    [newsArray replaceObjectAtIndex:i withObject:news];
                }
            }
            for (News *cacheNews in cacheNewsArray)
            {
                for (int i = 0; i < [newsArray count]; i ++)
                {
                    News *news = [newsArray objectAtIndex:i];
                    if ([cacheNews.newsId isEqualToNumber:news.newsId]
                        && cacheNews.updateTimeStamp != news.updateTimeStamp)
                    {
                        news.hasUpdated = YES;
                        [newsArray replaceObjectAtIndex:i withObject:news];
                    }
                }
            }
        }
        else
        {
            for (int i = 0; i < [newsArray count]; i ++)
            {
                News *news = [newsArray objectAtIndex:i];
                news.hasUpdated = YES;
                [newsArray replaceObjectAtIndex:i withObject:news];
            }
        }



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
        NSMutableArray *newsArray = nil;
        if (cacheResult.isSuccess)
        {
            newsArray = [self getListByDictionary:cacheResult.data];
            currentResult.isSuccess = YES;
            currentResult.data = newsArray;
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
    NSMutableArray *newsArray = [[NSMutableArray alloc] init];
    if (dict != nil)
    {
        NSDictionary *status = [dict objectForKey:kStatus];
        NSInteger statusCode = [[status objectForKey:kStatusCode] integerValue];
        if (statusCode == 1)
        {
            NSDictionary *list = [dict objectForKey:kList];
            for (NSDictionary *info in list)
            {
                NSNumber *newsId = [NSNumber numberWithInteger:[[info objectForKey:kNewsId] integerValue]];
                NSString *coverImageUrlString = nil;
                if ([[UIScreen mainScreen] scale] == 2.0f)
                {
                    coverImageUrlString = [info objectForKey:k3Dot5InchCoverImageUrlString];
                }
                else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
                {
                    coverImageUrlString = [info objectForKey:k3InchCoverImageUrlString];
                }
                NSString *thumbImageUrlString = nil;
                if ([[UIScreen mainScreen] scale] == 2.0f)
                {
                    thumbImageUrlString = [info objectForKey:k3Dot5InchThumbImageUrlString];
                }
                else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
                {
                    thumbImageUrlString = [info objectForKey:k3InchThumbImageUrlString];
                }
                NSInteger updateTimeStamp = [[info objectForKey:kUpdateTimeStamp] integerValue];
                News *news = [[News alloc] initWithAttributes:newsId
                                                        title:[info objectForKey:kTitle]
                                                 categoryName:[info objectForKey:kCategoryName]
                                                      summary:[info objectForKey:kSummary]
                                                     contents:nil
                                          coverImageUrlString:coverImageUrlString
                                          thumbImageUrlString:thumbImageUrlString
                                                  releaseDate:[info objectForKey:kReleaseDate]
                                              updateTimeStamp:updateTimeStamp];
                [newsArray addObject:news];
            }
        }
    }
    return newsArray;
}

+ (Result*)getDetail:(NSNumber*)newsId
{
    Result *currentResult = [[Result alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone") forKey:kDevice];
    [params setObject:[LanguageHelper getCurrentLanguage] forKey:kLanguage];
    [params setObject:[newsId stringValue] forKey:kNewsId];
    WebApi *api = [[WebApi alloc] initWithAttributes:@"getArticleDetail" params:params];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable)
    {
        // Get data
        Result *apiResult = [api getData];
        if (apiResult.isSuccess == NO)
        {
            return apiResult;
        }

        
        News *news = [self getInfoByDictionary:apiResult.data];
        currentResult.isSuccess = YES;
        currentResult.data = news;
        
        
        // Compare data
        Result *cacheResult = [api getCacheFileDictionaryData];
        if (cacheResult.isSuccess)
        {
            News *cacheNews = [self getInfoByDictionary:cacheResult.data];
            if (cacheNews == nil ||
                (cacheNews != nil && cacheNews.updateTimeStamp != cacheNews.updateTimeStamp))
            {
                news.hasUpdated = YES;
            }
        }
        else
        {
            news.hasUpdated = YES;
        }
        if (news.hasUpdated)
        {
            for (int i = 0; i < [news.images count]; i++)
            {
                NewsImage *newsImage = [news.images objectAtIndex:i];
                newsImage.hasUpdated = YES;
                [news.images replaceObjectAtIndex:i withObject:newsImage];
            }
        }
        
        
        
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
        News *news = nil;
        if (cacheResult.isSuccess)
        {
            news = [self getInfoByDictionary:cacheResult.data];
            currentResult.isSuccess = YES;
            currentResult.data = news;
        }
        else
        {
            currentResult.isSuccess = NO;
            currentResult.error = cacheResult.error;
        }
    }

    return currentResult;
}

+ (News*)getInfoByDictionary:(NSDictionary*)dict
{    
    News *news = nil;
    if (dict != nil)
    {
        NSDictionary *status = [dict objectForKey:kStatus];
        NSInteger statusCode = [[status objectForKey:kStatusCode] integerValue];
        if (statusCode == 1)
        {
            NSDictionary *info = [dict objectForKey:kDetail];
            NSNumber *newsId = [NSNumber numberWithInteger:[[info objectForKey:kNewsId] integerValue]];
            NSInteger updateTimeStamp = [[info objectForKey:kUpdateTimeStamp] integerValue];
            news = [[News alloc] initWithAttributes:newsId
                                              title:[info objectForKey:kTitle]
                                       categoryName:[info objectForKey:kCategoryName]
                                            summary:nil
                                           contents:[info objectForKey:kContent]
                                coverImageUrlString:nil
                                thumbImageUrlString:nil
                                        releaseDate:[info objectForKey:kReleaseDate]
                                    updateTimeStamp:updateTimeStamp];
            
            news.images = [[NSMutableArray alloc] init];
            NSDictionary *gallery = [info objectForKey:kGallery];
            for (NSDictionary *image in gallery)
            {
                NSNumber *newsImageId = [NSNumber numberWithInteger:[[image objectForKey:kNewsImageId] integerValue]];
                NSString *imageUrlString = nil;
                if ([[UIScreen mainScreen] scale] == 2.0f)
                {
                    imageUrlString = [image objectForKey:k3Dot5InchGalleryImageUrlString];
                }
                else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
                {
                    imageUrlString = [image objectForKey:k3InchGalleryImageUrlString];
                }
                NewsImage *newsImage = [[NewsImage alloc] initWithAttributes:newsImageId
                                                                      newsId:newsId
                                                                       title:[image objectForKey:kTitle]
                                                               imageUrlString:imageUrlString];
                [news.images addObject:newsImage];
            }
        }
    }
    return news;
}

@end
