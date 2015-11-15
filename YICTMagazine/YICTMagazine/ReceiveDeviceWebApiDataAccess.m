//
//  ReceiveDeviceWebApiDataAccess.m
//  YICTMagazine
//
//  Created by Seven on 13-9-12.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kDevice @"source"
#define kLanguage @"lang"
#define kDeviceToken @"deviceToken"
#define kIsSubscribe @"isSubscribe"
#define kStatus @"status"
#define kStatusCode @"code"
#define kStatusMessage @"message"
#define kList @"list"
#define kNewsCategoryId @"categoryId"
#define kNewsCategoryIds @"categoryIds"

#import "ReceiveDeviceWebApiDataAccess.h"
#import "AppDelegate.h"
#import "WebApi.h"
#import "LanguageHelper.h"

@implementation ReceiveDeviceWebApiDataAccess

+ (Result*)syncDeviceToken:(NSString*)deviceTokenString isSubscribe:(BOOL)isSubscribe
{
    Result *currentResult = [[Result alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone") forKey:kDevice];
    [params setObject:[LanguageHelper getCurrentLanguage] forKey:kLanguage];
    [params setObject:deviceTokenString forKey:kDeviceToken];
    [params setObject:(isSubscribe ? @"1" : @"0") forKey:kIsSubscribe];
    WebApi *api = [[WebApi alloc] initWithAttributes:@"syncDeviceToken" params:params];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable)
    {
        // Get data
        Result *apiResult = [api getData];
        if (apiResult.isSuccess == NO)
        {
            return apiResult;
        }
        
        NSDictionary *returnData = apiResult.data;
        if (returnData != nil)
        {
            NSDictionary *status = [returnData objectForKey:kStatus];
            NSInteger statusCode = [[status objectForKey:kStatusCode] integerValue];
            if (statusCode == 1)
            {
                currentResult.isSuccess = YES;
            }
            else
            {
                NSString *message = [status objectForKey:kStatusMessage];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:message forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:kWebApiAccessDomainName
                                                     code:200
                                                 userInfo:dict];
                currentResult.error = error;
            }
        }
    }
    else
    {
        currentResult.isSuccess = NO;
        currentResult.error = [api offlineError];
    }
    
    return currentResult;
}

+ (Result*)syncNotificationNewsCategoryList:(NSString*)deviceTokenString
                     newsCategoryIdArray:(NSArray*)newsCategoryIdArray
{
    Result *currentResult = [[Result alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone") forKey:kDevice];
    [params setObject:[LanguageHelper getCurrentLanguage] forKey:kLanguage];
    [params setObject:deviceTokenString forKey:kDeviceToken];
    if ([newsCategoryIdArray count] > 0)
    {
        [params setObject:[newsCategoryIdArray componentsJoinedByString:@","]
                   forKey:kNewsCategoryIds];
    }
    else
    {
        [params setObject:@"" forKey:kNewsCategoryIds];
    }
    WebApi *api = [[WebApi alloc] initWithAttributes:@"syncNotificationNewsCategoryList" params:params];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable)
    {
        // Get data
        Result *apiResult = [api getData];
        if (apiResult.isSuccess == NO)
        {
            return apiResult;
        }
        
        NSDictionary *returnData = apiResult.data;
        if (returnData != nil)
        {
            NSDictionary *status = [returnData objectForKey:kStatus];
            NSInteger statusCode = [[status objectForKey:kStatusCode] integerValue];
            if (statusCode == 1)
            {
                currentResult.isSuccess = YES;
            }
            else
            {
                currentResult.error = [api offlineError];
            }
        }
    }
    else
    {
        currentResult.isSuccess = NO;
        currentResult.error = [api offlineError];
    }
    
    return currentResult;
}

@end
