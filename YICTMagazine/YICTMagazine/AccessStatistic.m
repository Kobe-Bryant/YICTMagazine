//
//  AccessStatistic.m
//  YICTMagazine
//
//  Created by LaiZhaowu on 13-10-9.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "AccessStatistic.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "AccessStatisticWebApiDataAccess.h"

@implementation AccessStatistic

//- (id)initWithAttributes:(NSString*)ipAddress
//{
//    _ipAddress = ipAddress;
//    return self;
//}

//- (NSString *)getCurrentIpAddress
//{
//    NSString *address = @"error";
//    struct ifaddrs *interfaces = NULL;
//    struct ifaddrs *temp_addr = NULL;
//    int success = 0;
//    // retrieve the current interfaces - returns 0 on success
//    success = getifaddrs(&interfaces);
//    if (success == 0)
//    {
//        // Loop through linked list of interfaces
//        temp_addr = interfaces;
//        while (temp_addr != NULL)
//        {
//            if (temp_addr->ifa_addr->sa_family == AF_INET)
//            {
//                // Check if interface is en0 which is the wifi connection on the iPhone
//                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
//                {
//                    // Get NSString from C String
//                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
//                }
//            }
//            
//            temp_addr = temp_addr->ifa_next;
//        }
//    }
//    // Free memory
//    freeifaddrs(interfaces);
//    return address;
//}

//- (void)setIpAddressToCurrentIpAddress
//{
//    _ipAddress = [self getCurrentIpAddress];
//}

+ (Result*)send
{
    return [AccessStatisticWebApiDataAccess send];
}

@end
