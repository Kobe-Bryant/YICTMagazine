//
//  About.h
//  YICTMagazine
//
//  Created by Seven on 13-9-13.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface About : NSObject

@property (nonatomic, retain) NSString *contents;

- (id)initWithAttributes:(NSString*)contents;

+ (Result*)getInfo;

@end
