//
//  ReceiveDeviceWebApiDataAccess.h
//  YICTMagazine
//
//  Created by Seven on 13-9-12.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReceiveDevice.h"

@interface ReceiveDeviceWebApiDataAccess : NSObject

+ (Result*)syncDeviceToken:(NSString*)deviceTokenString isSubscribe:(BOOL)isSubscribe;

+ (Result*)syncNotificationNewsCategoryList:(NSString*)deviceTokenString
                        newsCategoryIdArray:(NSArray*)newsCategoryIdArray;

@end
