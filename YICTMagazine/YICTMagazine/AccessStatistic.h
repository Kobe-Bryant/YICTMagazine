//
//  AccessStatistic.h
//  YICTMagazine
//
//  Created by LaiZhaowu on 13-10-9.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface AccessStatistic : NSObject

//@property (nonatomic, retain) NSString *ipAddress;

//- (id)initWithAttributes:(NSString*)ipAddress;

//- (NSString *)getCurrentIpAddress;

//- (void)setIpAddressToCurrentIpAddress;

+ (Result *)send;

@end
