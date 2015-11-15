//
//  BaseModel.h
//  YICTMagazine
//
//  Created by Seven on 13-9-13.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Result : NSObject

@property (nonatomic, readwrite) BOOL isSuccess;
@property (nonatomic, retain) id data;
@property (nonatomic, readwrite) BOOL hasError;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, readwrite) BOOL hasUpdated;

@end
