//
//  LaunchImageWebApiDataAccess.m
//  YICTMagazine
//
//  Created by Seven on 13-9-3.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kDevice @"source"
#define kLanguage @"lang"
#define kStatus @"status"
#define kStatusCode @"code"
#define kStatusMessage @"message"
#define kBanner @"banner"
#define k3InchImageUrlString @"photoSmall"
#define k3Dot5InchImageUrlString @"photoMedium"
#define k4InchImageUrlString @"photoLarge"
#define kScrollDirection @"scrollDirection"
#define kUpdateTimeStamp @"updateTime"

#import "LaunchImageWebApiDataAccess.h"
#import "AppDelegate.h"
#import "WebApi.h"
#import "LanguageHelper.h"

@implementation LaunchImageWebApiDataAccess

+ (Result*)getInfo
{
    Result *currentResult = [[Result alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone") forKey:kDevice];
    [params setObject:[LanguageHelper getCurrentLanguage] forKey:kLanguage];
    WebApi *api = [[WebApi alloc] initWithAttributes:@"getWelcomeBanner" params:params];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable)
    {
        // Get data
        Result *apiResult = [api getData];
        if (apiResult.isSuccess == NO)
        {
            return apiResult;
        }
        
        LaunchImage *launchImage = [self getInfoByDictionary:apiResult.data];
        currentResult.isSuccess = YES;
        currentResult.data = launchImage;
        
                
        // Compare data
        Result *cacheResult = [api getCacheFileDictionaryData];
        if (cacheResult.isSuccess)
        {
            LaunchImage *cacheLaunchImage = [self getInfoByDictionary:cacheResult.data];
            if (cacheLaunchImage == nil ||
                (cacheLaunchImage != nil && cacheLaunchImage.updateTimeStamp != launchImage.updateTimeStamp))
            {
                launchImage.hasUpdated = YES;
            }
        }
        else
        {
            launchImage.hasUpdated = YES;
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
        LaunchImage *launchImage = nil;
        if (cacheResult.isSuccess)
        {
            launchImage = [self getInfoByDictionary:cacheResult.data];
            currentResult.isSuccess = YES;
            currentResult.data = launchImage;
        }
        else
        {
            currentResult.isSuccess = NO;
            currentResult.error = cacheResult.error;
        }
    }

    return currentResult;
}

+ (LaunchImage*)getInfoByDictionary:(NSDictionary*)dict
{    
    LaunchImage *launchImage = nil;
    if (dict != nil)
    {
        NSDictionary *status = [dict objectForKey:kStatus];
        NSInteger statusCode = [[status objectForKey:kStatusCode] integerValue];
        if (statusCode == 1)
        {
            NSDictionary *info = [dict objectForKey:kBanner];
            
            NSString *imageUrlString = nil;
            if ([[UIScreen mainScreen] scale] == 2.0f
                && [[UIScreen mainScreen] bounds].size.height == 568.0f)
            {
                imageUrlString = [info objectForKey:k4InchImageUrlString];
            }
            else if ([[UIScreen mainScreen] scale] == 2.0f
                     && [[UIScreen mainScreen] bounds].size.height == 480.0f)
            {
                imageUrlString = [info objectForKey:k3Dot5InchImageUrlString];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
            {
                imageUrlString = [info objectForKey:k3InchImageUrlString];
            }
            
            BOOL isLeftToRight = NO;
            if (![[info objectForKey:kScrollDirection] isEqualToString:@"RightToLeft"])
            {
                isLeftToRight = YES;
            }
            
            NSInteger updateTimeStamp = [[info objectForKey:kUpdateTimeStamp] integerValue];
            launchImage = [[LaunchImage alloc] initWithAttributes:imageUrlString
                                                    isLeftToRight:isLeftToRight
                                                  updateTimeStamp:updateTimeStamp];
        }
    }
    
    return launchImage;
}

@end
