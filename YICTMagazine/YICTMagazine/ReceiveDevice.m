//
//  ReceiveDevice.m
//  YICTMagazine
//
//  Created by Seven on 13-9-12.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "ReceiveDevice.h"
#import "ReceiveDeviceWebApiDataAccess.h"

@implementation ReceiveDevice

- (id)initWithAttributes:(NSString*)deviceTokenString isSubscribe:(BOOL)isSubscribe
{
    _deviceTokenString = deviceTokenString;
    _isSubscribe = isSubscribe;
    return self;
}

- (Result*)syncDeviceToken
{
    return [ReceiveDeviceWebApiDataAccess syncDeviceToken:_deviceTokenString
                                              isSubscribe:_isSubscribe];
}

- (Result*)syncNotificationNewsCategoryList:(NSArray*)newsCategoryIdArray
{
    return [ReceiveDeviceWebApiDataAccess syncNotificationNewsCategoryList:_deviceTokenString
                                                       newsCategoryIdArray:newsCategoryIdArray];
}

@end
