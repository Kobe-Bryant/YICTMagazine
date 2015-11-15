//
//  AccessStatisticWebApiDataAccess.m
//  YICTMagazine
//
//  Created by LaiZhaowu on 13-10-9.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kDevice @"source"
#define kLanguage @"lang"
#define kIpAddress @"ip"
#define kStatus @"status"
#define kStatusCode @"code"
#define kDetail @"Detail"
#define kContent @"content"

#import "AccessStatisticWebApiDataAccess.h"
#import "AppDelegate.h"
#import "WebApi.h"
#import "LanguageHelper.h"

@implementation AccessStatisticWebApiDataAccess

+ (Result *)send
{
    Result *currentResult = [[Result alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone") forKey:kDevice];
    [params setObject:[LanguageHelper getCurrentLanguage] forKey:kLanguage];
    WebApi *api = [[WebApi alloc] initWithAttributes:@"visitStatistics" params:params];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable)
    {
        // Get data
        Result *apiResult = [api getData];
        return apiResult;
    }
    else
    {
        currentResult.isSuccess = NO;
        currentResult.error = [api offlineError];
    }
    
    return currentResult;
}

@end
