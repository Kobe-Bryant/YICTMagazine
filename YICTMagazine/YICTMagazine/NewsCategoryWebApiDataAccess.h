//
//  NewsCategoryDataAccess.h
//  YICTMagazine
//
//  Created by Seven on 13-8-30.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsCategory.h"

@interface NewsCategoryWebApiDataAccess : NSObject

+ (Result*)getList;

@end
