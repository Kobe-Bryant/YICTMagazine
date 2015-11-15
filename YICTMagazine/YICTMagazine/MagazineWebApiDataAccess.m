//
//  MagazineWebApiDataAccess.m
//  YICTMagazine
//
//  Created by Seven on 13-9-2.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kDevice @"source"
#define kLanguage @"lang"
#define kMagazineId @"id"
#define kIsDisplayAtHomeView @"isIndex"
#define kIsNew @"isNew"
#define kOffset @"offsetStart"
#define kLimit @"maxPageItems"
#define kStatus @"status"
#define kStatusCode @"code"
#define kDetail @"Detail"
#define kList @"list"
#define kGallery @"galleryList"
#define kMagazineImageId @"id"
#define kTitle @"title"
#define k3InchCoverImageUrlString @"photoSmall"
#define k3Dot5InchCoverImageUrlString @"photoMedium"
#define kPdfFileUrlString @"downloadFile"
#define kSummary @"summary"
#define kGallery @"galleryList"
#define k3InchThumbImageUrlString @"thumbPhotoSmall"
#define k3Dot5InchThumbImageUrlString @"thumbPhotoLarge"
#define k3InchOrigImageUrlString @"photoSmall"
#define k3DotInchOrigImageUrlString @"photoLarge"
#define kCatalogList @"catalogList"
#define kCatalogTitle @"catalog"
#define kUpdateTimeStamp @"updateTime"

#import "MagazineWebApiDataAccess.h"
#import "AppDelegate.h"
#import "WebApi.h"
#import "LanguageHelper.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation MagazineWebApiDataAccess

+ (Result*)getList:(BOOL)isDisplayAtHomeView
             isNew:(BOOL)isNew
            offset:(NSUInteger)offset
             limit:(NSUInteger)limit
{
    Result *currentResult = [[Result alloc] init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone") forKey:kDevice];
    [params setObject:[LanguageHelper getCurrentLanguage] forKey:kLanguage];
    [params setObject:(isDisplayAtHomeView ? @"1" : @"0") forKey:kIsDisplayAtHomeView];
    [params setObject:(isNew ? @"1" : @"0") forKey:kIsNew];
    if (limit > 0)
    {
        [params setObject:[[NSString alloc] initWithFormat:@"%i", offset] forKey:kOffset];
        [params setObject:[[NSString alloc] initWithFormat:@"%i", limit] forKey:kLimit];
    }
    else
    {
        [params setObject:@"-1" forKey:kOffset];
        [params setObject:@"-1" forKey:kLimit];
    }
    WebApi *api = [[WebApi alloc] initWithAttributes:@"getMagazineList" params:params];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable)
    {
        // Get data
        Result *apiResult = [api getData];
        if (apiResult.isSuccess == NO)
        {
            return apiResult;
        }
        
        
        NSMutableArray *magazineArray = [self getListByDictionary:apiResult.data];
        currentResult.isSuccess = YES;
        
        
        // Reset download status
        for (int i = 0; i < [magazineArray count]; i ++)
        {
            Magazine *magazine = [magazineArray objectAtIndex:i];
            magazine.hasDownloaded = [self getDownloadStatus:magazine.magazineId];
            if (magazine.hasDownloaded)
            {
                [magazineArray replaceObjectAtIndex:i withObject:magazine];
            }
        }
        currentResult.data = magazineArray;

        
        // Compare data
        Result *cacheResult = [api getCacheFileDictionaryData];
        if (cacheResult.isSuccess)
        {
            NSMutableArray *cacheMagazineArray = [self getListByDictionary:cacheResult.data];
            for (int i = 0; i < [magazineArray count]; i ++)
            {
                Magazine *magazine = [magazineArray objectAtIndex:i];
                BOOL isExisted = NO;
                for (Magazine *cacheMagazine in cacheMagazineArray)
                {
                    if ([magazine.magazineId isEqualToNumber:cacheMagazine.magazineId])
                    {
                        isExisted = YES;
                    }
                }
                if (isExisted == NO)
                {
                    magazine.hasUpdated = YES;
                    [magazineArray replaceObjectAtIndex:i withObject:magazine];
                }
            }
            for (Magazine *cacheMagazine in cacheMagazineArray)
            {
                for (int i = 0; i < [magazineArray count]; i ++)
                {
                    Magazine *magazine = [magazineArray objectAtIndex:i];
                    if ([cacheMagazine.magazineId isEqualToNumber:magazine.magazineId]
                        && cacheMagazine.updateTimeStamp != magazine.updateTimeStamp)
                    {
                        magazine.hasUpdated = YES;
                        [magazineArray replaceObjectAtIndex:i withObject:magazine];
                    }
                }
            }
        }
        else
        {
            for (int i = 0; i < [magazineArray count]; i ++)
            {
                Magazine *magazine = [magazineArray objectAtIndex:i];
                magazine.hasUpdated = YES;
                [magazineArray replaceObjectAtIndex:i withObject:magazine];
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
        NSMutableArray *magazineArray = nil;
        if (cacheResult.isSuccess)
        {
            magazineArray = [self getListByDictionary:cacheResult.data];
            
            
            // Reset download status
            for (int i = 0; i < [magazineArray count]; i ++)
            {
                Magazine *magazine = [magazineArray objectAtIndex:i];
                magazine.hasDownloaded = [self getDownloadStatus:magazine.magazineId];
                if (magazine.hasDownloaded)
                {
                    [magazineArray replaceObjectAtIndex:i withObject:magazine];
                }
            }
            
            
            currentResult.isSuccess = YES;
            currentResult.data = magazineArray;
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
    NSMutableArray *magazineArray = [[NSMutableArray alloc] init];
    if (dict != nil)
    {
        NSDictionary *status = [dict objectForKey:kStatus];
        NSInteger statusCode = [[status objectForKey:kStatusCode] integerValue];
        if (statusCode == 1)
        {
            NSDictionary *list = [dict objectForKey:kList];
            for (NSDictionary *info in list)
            {
                NSNumber *magazineId = [NSNumber numberWithInteger:[[info objectForKey:kMagazineId] integerValue]];
                NSString *coverImageUrlString = nil;
                if ([[UIScreen mainScreen] scale] == 2.0f)
                {
                    coverImageUrlString = [info objectForKey:k3Dot5InchCoverImageUrlString];
                }
                else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
                {
                    coverImageUrlString = [info objectForKey:k3InchCoverImageUrlString];
                }
                NSInteger updateTimeStamp = [[info objectForKey:kUpdateTimeStamp] integerValue];
                Magazine *magazine = [[Magazine alloc] initWithAttributes:magazineId
                                                                    title:[info objectForKey:kTitle]
                                                      coverImageUrlString:coverImageUrlString
                                                          updateTimeStamp:updateTimeStamp];
                [magazineArray addObject:magazine];
            }
        }
    }
    
    return magazineArray;
}


+ (Result*)getDetail:(NSNumber*)magazineId
{
    Result *currentResult = [[Result alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone") forKey:kDevice];
    [params setObject:[LanguageHelper getCurrentLanguage] forKey:kLanguage];
    [params setObject:[magazineId stringValue] forKey:kMagazineId];
    WebApi *api = [[WebApi alloc] initWithAttributes:@"getMagazineDetail" params:params];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable)
    {
        // Get data
        Result *apiResult = [api getData];
        if (apiResult.isSuccess == NO)
        {
            return apiResult;
        }
        
        
        Magazine *magazine = [self getInfoByDictionary:apiResult.data];
        currentResult.isSuccess = YES;
        
        
        // Reset download status
        magazine.hasDownloaded = [self getDownloadStatus:magazine.magazineId];
        currentResult.data = magazine;
        
        
        // Compare data
        Result *cacheResult = [api getCacheFileDictionaryData];
        if (cacheResult.isSuccess)
        {
            Magazine *cacheMagazine = [self getInfoByDictionary:cacheResult.data];
            if (cacheMagazine == nil ||
                (cacheMagazine != nil && cacheMagazine.updateTimeStamp != magazine.updateTimeStamp))
            {
                magazine.hasUpdated = YES;
            }
        }
        else
        {
            magazine.hasUpdated = YES;
        }
        if (magazine.hasUpdated)
        {
            for (int i = 0; i < [magazine.images count]; i++)
            {
                MagazineImage *magazineImage = [magazine.images objectAtIndex:i];
                magazineImage.hasUpdated = YES;
                [magazine.images replaceObjectAtIndex:i withObject:magazineImage];
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
        Magazine *magazine = nil;
        if (cacheResult.isSuccess)
        {
            magazine = [self getInfoByDictionary:cacheResult.data];
            currentResult.isSuccess = YES;
            currentResult.data = magazine;
        }
        else
        {
            currentResult.isSuccess = NO;
            currentResult.error = cacheResult.error;
        }
    }
    
    return currentResult;
}

+ (Magazine*)getInfoByDictionary:(NSDictionary*)dict
{
    Magazine *magazine = nil;
    if (dict != nil)
    {        
        NSDictionary *status = [dict objectForKey:kStatus];
        NSInteger statusCode = [[status objectForKey:kStatusCode] integerValue];
        if (statusCode == 1)
        {
            NSDictionary *info = [dict objectForKey:kDetail];
            NSNumber *mangazineId = [NSNumber numberWithInteger:[[info objectForKey:kMagazineId] integerValue]];
            NSInteger updateTimeStamp = [[info objectForKey:kUpdateTimeStamp] integerValue];
            magazine = [[Magazine alloc] initWithAttributes:mangazineId
                                                      title:[info objectForKey:kTitle]
                                        coverImageUrlString:nil
                                            updateTimeStamp:updateTimeStamp];

            NSDictionary *gallery = [info objectForKey:kGallery];
            magazine.images = [[NSMutableArray alloc] init];
            for (NSDictionary *image in gallery)
            {
                NSNumber *magazineImageId = [NSNumber numberWithInteger:[[image objectForKey:kMagazineImageId] integerValue]];
                
                NSString *thumbImageUrlString = nil;
                if ([[UIScreen mainScreen] scale] == 2.0f)
                {
                    thumbImageUrlString = [image objectForKey:k3Dot5InchThumbImageUrlString];
                }
                else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
                {
                    thumbImageUrlString = [image objectForKey:k3InchThumbImageUrlString];
                }
                
                NSString *origImageUrlString = nil;
                if ([[UIScreen mainScreen] scale] == 2.0f)
                {
                    origImageUrlString = [image objectForKey:k3DotInchOrigImageUrlString];
                }
                else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
                {
                    origImageUrlString = [image objectForKey:k3DotInchOrigImageUrlString];
                }
                
                MagazineImage *magazineImage = [[MagazineImage alloc] initWithAttributes:magazineImageId
                                                                              magazineId:mangazineId
                                                                                   title:[image objectForKey:kTitle]
                                                                     thumbImageUrlString:thumbImageUrlString
                                                                      origImageUrlString:origImageUrlString];
                [magazine.images addObject:magazineImage];
            }
            
            NSDictionary *catalogs = [info objectForKey:kCatalogList];
            magazine.catalogs = [[NSMutableArray alloc] init];
            for (NSDictionary *catalog in catalogs)
            {
                NSNumber *magazineImageId = [NSNumber numberWithInteger:[[catalog objectForKey:kMagazineImageId] integerValue]];
                MagazineCatalog *magazineCatalog = [[MagazineCatalog alloc] initWithAttributes:nil
                                                                              magazineId:mangazineId
                                                           magazineImageId:magazineImageId                       title:[catalog objectForKey:kCatalogTitle]];
                [magazine.catalogs addObject:magazineCatalog];
            }
        }
    }

    return magazine;
}

+ (BOOL)refreshDownloadStatus:(Magazine*)magazine
{
    NSInteger downloadedThumbImageCount = 0;
    NSInteger downloadedOrigImageCount = 0;
    if ([magazine.images count] > 0)
    {
        for (MagazineImage *magazineImage in magazine.images)
        {
            if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:magazineImage.thumbImageUrlString] != nil)
            {
                downloadedThumbImageCount++;
            }
            if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:magazineImage.origImageUrlString] != nil)
            {
                downloadedOrigImageCount++;
            }
        }
        if ([magazine.images count] == downloadedThumbImageCount
            && [magazine.images count] == downloadedOrigImageCount)
        {
            [self saveDownloadedStatus:magazine.magazineId];
            return YES;
        }
        else
        {
            [self saveUndownloadedStatus:magazine.magazineId];
        }
    }
    
    return NO;
}

+ (void)saveDownloadedStatus:(NSNumber*)magazineId
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *rootPath = [[NSString alloc] initWithFormat:@"%@/Magazine", [WebApi getCacheRootDir]];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:rootPath isDirectory:&isDir])
    {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:rootPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
    }
    
    NSString *magazinePath = [[NSString alloc] initWithFormat:@"%@/Magazine/%@",
                              [WebApi getCacheRootDir],
                              [magazineId stringValue]];
    if (![fileManager fileExistsAtPath:magazinePath isDirectory:&isDir])
    {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:magazinePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
    }
    
    
    NSString *filePath = [[NSString alloc] initWithFormat:@"%@/DownloadStatus.txt", magazinePath];
    NSString *downloadStatus = @"1";
    NSData *data = [downloadStatus dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:filePath atomically:YES];
}

+ (void)saveUndownloadedStatus:(NSNumber*)magazineId
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *rootPath = [[NSString alloc] initWithFormat:@"%@/Magazine", [WebApi getCacheRootDir]];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:rootPath isDirectory:&isDir])
    {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:rootPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
    }
    
    NSString *magazinePath = [[NSString alloc] initWithFormat:@"%@/Magazine/%@",
                              [WebApi getCacheRootDir],
                              [magazineId stringValue]];
    if (![fileManager fileExistsAtPath:magazinePath isDirectory:&isDir])
    {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:magazinePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
    }
    
    
    NSString *filePath = [[NSString alloc] initWithFormat:@"%@/DownloadStatus.txt", magazinePath];
    NSString *downloadStatus = @"0";
    NSData *data = [downloadStatus dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:filePath atomically:YES];
}

+ (BOOL)getDownloadStatus:(NSNumber*)magazineId
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[NSString alloc] initWithFormat:@"%@/Magazine/%@/DownloadStatus.txt",
                          [WebApi getCacheRootDir],
                          magazineId];
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        NSString *downloadStatus = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return [downloadStatus isEqualToString:@"1"];
    }
    
    return NO;
}

@end
