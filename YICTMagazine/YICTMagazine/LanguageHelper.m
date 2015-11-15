//
//  LanguageHelper.m
//  YICTMagazine
//
//  Created by Seven on 13-9-13.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "LanguageHelper.h"

@implementation LanguageHelper

+ (NSString*)getCurrentLanguage
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* langs = [userDefaults objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [langs objectAtIndex:0];
    if ([preferredLang isEqualToString:@"zh-Hans"])
    {
        return @"zh_CN";
    }
    return @"en_US";
}

@end
