//
//  AboutWebApiDataAccess.m
//  YICTMagazine
//
//  Created by Seven on 13-9-13.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kDevice @"source"
#define kLanguage @"lang"
#define kStatus @"status"
#define kStatusCode @"code"
#define kDetail @"Detail"
#define kContent @"content"

#import "AboutWebApiDataAccess.h"
#import "AppDelegate.h"
#import "WebApi.h"
#import "LanguageHelper.h"

@implementation AboutWebApiDataAccess

+ (Result*)getInfo
{
    Result *currentResult = [[Result alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone") forKey:kDevice];
    [params setObject:[LanguageHelper getCurrentLanguage] forKey:kLanguage];
    WebApi *api = [[WebApi alloc] initWithAttributes:@"getCompanyProfile" params:params];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable)
    {
        // Get data
        Result *apiResult = [api getData];
        if (apiResult.isSuccess == NO)
        {
            return apiResult;
        }
        
        About *about = [self getInfoByDictionary:apiResult.data];
        currentResult.isSuccess = YES;
        currentResult.data = about;
        
        
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
        About *about = nil;
        if (cacheResult.isSuccess)
        {
            about = [self getInfoByDictionary:cacheResult.data];
            currentResult.isSuccess = YES;
            currentResult.data = about;
        }
        else
        {
            currentResult.isSuccess = NO;
            currentResult.error = cacheResult.error;
        }
    }
    
    return currentResult;
}

+ (About*)getInfoByDictionary:(NSDictionary*)dict
{
    About *about = nil;
    if (dict != nil)
    {
        NSDictionary *status = [dict objectForKey:kStatus];
        NSInteger statusCode = [[status objectForKey:kStatusCode] integerValue];
        if (statusCode == 1)
        {
            NSDictionary *info = [dict objectForKey:kDetail];
            about = [[About alloc] initWithAttributes:[info objectForKey:kContent]];
        }
    }
    return about;
}

@end
