//
//  WebApiData.h
//  YICTMagazine
//
//  Created by Seven on 13-9-13.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebApiAccessConfig.h"
#import "Result.h"

@interface WebApi : NSObject

@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSDictionary *params;
@property (nonatomic, retain) NSData *returnData;
@property (nonatomic, retain) NSData *cacheData;

- (id)initWithAttributes:(NSString*)method params:(NSDictionary*)params;

- (NSString*)getSignature;

- (NSURL*)getAccessUrl;

- (Result*)getData;

+ (NSString*)getCacheRootDir;

- (NSData*)getCacheFileData;

- (Result*)getCacheFileDictionaryData;

- (void)saveCacheData;

- (NSError*)offlineError;

@end
