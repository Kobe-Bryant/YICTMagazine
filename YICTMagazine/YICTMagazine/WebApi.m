//
//  WebApiData.m
//  YICTMagazine
//
//  Created by Seven on 13-9-13.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kCacheFileExt @"txt"

#import "WebApi.h"
#import "NSString+MD5.h"

@implementation WebApi

@synthesize returnData;

- (id)initWithAttributes:(NSString*)method params:(NSDictionary*)params;
{
    _method = [method copy];
    _params = [params copy];
    return self;
}

- (NSString*)getSignature
{
    NSMutableArray *orderedKeys = [[NSMutableArray alloc] init];
    for (NSString *key in _params)
    {
        [orderedKeys addObject:key];
    }
    [orderedKeys sortUsingSelector:@selector(compare:)];
    
    NSString *signature = @"";
    for (NSString *key in orderedKeys)
    {
        if (key != nil)
        {
            signature = [signature stringByAppendingString:key];
            signature = [signature stringByAppendingString:@"="];
            signature = [signature stringByAppendingString:[self.params objectForKey:key]];
        }
    }
    signature = [signature stringByAppendingString:kWebApiAccessMixCode];
    return [[signature MD5String] uppercaseString];
}

- (NSURL*)getAccessUrl
{
    NSString *urlString = kWebApiAccessProtocol;
    urlString = [urlString stringByAppendingString:@"://"];
    urlString = [urlString stringByAppendingString:kWebApiAccessDomainName];
    urlString = [urlString stringByAppendingString:@"/API/"];
    urlString = [urlString stringByAppendingString:_method];
    urlString = [urlString stringByAppendingString:@"."];
    urlString = [urlString stringByAppendingString:kWebApiAccessFileSuffix];
    return [[NSURL alloc] initWithString:urlString];
}

- (NSError*)emptyReturnError
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"No return data from web API query." forKey:NSLocalizedDescriptionKey];
    
    NSError *error = [NSError errorWithDomain:kWebApiAccessDomainName
                                         code:100
                                     userInfo:dict];
    return error;
}

- (Result*)post
{
    // Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self getAccessUrl]];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [request setHTTPMethod:@"POST"];
    [request addValue:@"text/plain; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    // Post data
    NSString *postData = [[NSString alloc] init];
    postData = [postData stringByAppendingString:@"signature="];
    postData = [postData stringByAppendingString:[self getSignature]];
    
    for (NSString *key in _params)
    {
        if (key != nil)
        {
            postData = [postData stringByAppendingString:@"&"];
            postData = [postData stringByAppendingString:key];
            postData = [postData stringByAppendingString:@"="];
            postData = [postData stringByAppendingString:[_params objectForKey:key]];
        }
    }

    [request setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding
                                allowLossyConversion:YES]];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    // Get the response
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];

    // Return result
    Result *result = [[Result alloc] init];
    if (error == nil && response.statusCode == 200)
    {
        result.isSuccess = YES;
        result.data = responseData;
    }
    else
    {
        result.isSuccess = NO;
        result.error = error;
    }
    
    return result;
}

- (Result*)getData
{
    // Return data
    Result *postResult = [self post];
    if (postResult.isSuccess == NO)
    {
        return postResult;
    }
    
    Result *currentResult = [[Result alloc] init];
    self.returnData = postResult.data;
    if (self.returnData == nil)
    {
        currentResult.isSuccess = NO;
        currentResult.error = [self emptyReturnError];
        return currentResult;
    }
    
    
    // Process json data
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:returnData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    if (error == nil)
    {
        currentResult.isSuccess = YES;
        currentResult.data = dict;
    }
    else
    {
        currentResult.isSuccess = NO;
        currentResult.error = error;
    }
    
    return currentResult;
}

+ (NSString*)getCacheRootDir
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString* cacheDir = [paths objectAtIndex:0];
    return cacheDir;
}

- (NSString*)getCacheFileName
{
    return [[NSString alloc] initWithFormat:@"%@.%@", [self getSignature], kCacheFileExt];
}

- (NSString*)getCacheFilePath
{
    return [[NSString alloc] initWithFormat:@"%@/%@", [WebApi getCacheRootDir], [self getCacheFileName]];
}

- (NSData*)getCacheFileData
{
    self.cacheData = [[NSData alloc] initWithContentsOfFile:[self getCacheFilePath]];
    return self.cacheData;
}

- (Result*)getCacheFileDictionaryData
{
    Result *result = [[Result alloc] init];
    if (self.cacheData == nil)
    {
        self.cacheData = [self getCacheFileData];
    }

    if (self.cacheData == nil)
    {
        result.isSuccess = NO;
        result.error = [self offlineError];
        return result;
    }
    
    // Process json data
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.cacheData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    self.cacheData = nil;
    if (error == nil)
    {
        result.isSuccess = YES;
        result.data = dict;
    }
    else
    {
        result.isSuccess = NO;
        result.error = error;
    }
    
    return result;
}

- (void)saveCacheData
{
    if (self.returnData != nil)
    {
        [self.returnData writeToFile:[self getCacheFilePath] atomically:YES];
    }
}

- (NSError*)offlineError
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:NSLocalizedString(@"Please connect to network.", nil) forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:kWebApiAccessDomainName
                               code:200
                           userInfo:dict];
}

@end
