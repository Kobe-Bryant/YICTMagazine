//
//  LaunchImage.h
//  YICTMagazine
//
//  Created by Seven on 13-9-3.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface LaunchImage : NSObject

@property (nonatomic, retain) NSString *imageUrlString;
@property (nonatomic, readwrite) BOOL isLeftToRight;
@property (nonatomic, readwrite) NSUInteger updateTimeStamp;
@property (nonatomic, readwrite) BOOL hasUpdated;

- (id)initWithAttributes:(NSString*)imageUrlString
           isLeftToRight:(BOOL)isLeftToRight
         updateTimeStamp:(NSUInteger)updateTimeStamp;

+ (Result*)getInfo;

@end
