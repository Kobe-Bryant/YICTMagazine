//
//  About.m
//  YICTMagazine
//
//  Created by Seven on 13-9-13.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "About.h"
#import "AboutWebApiDataAccess.h"

@implementation About

- (id)initWithAttributes:(NSString*)contents
{
    _contents = contents;
    return self;
}

+ (Result*)getInfo
{
    return [AboutWebApiDataAccess getInfo];
}

@end
