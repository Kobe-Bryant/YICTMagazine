//
//  ReceiveDevice.h
//  YICTMagazine
//
//  Created by Seven on 13-9-12.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface ReceiveDevice : NSObject

@property (nonatomic, retain) NSString *deviceTokenString;
@property (nonatomic, readwrite) BOOL isSubscribe;

- (id)initWithAttributes:(NSString*)deviceTokenString isSubscribe:(BOOL)isSubscribe;

- (Result*)syncDeviceToken;

- (Result*)syncNotificationNewsCategoryList:(NSArray*)newsCategoryIdArray;

@end
