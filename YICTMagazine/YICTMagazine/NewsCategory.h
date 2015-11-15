//
//  NewsCategory.h
//  YICTMagazine
//
//  Created by Seven on 13-8-30.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface NewsCategory : NSObject

@property (nonatomic, retain) NSNumber *newsCategoryId;
@property (nonatomic, retain) NSString *title;

- (id)initWithAttributes:(NSNumber*)newsCategoryId title:(NSString*)title;

+ (Result*)getList;

@end
