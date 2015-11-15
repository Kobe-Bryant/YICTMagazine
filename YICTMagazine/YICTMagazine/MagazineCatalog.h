//
//  MagazineCatalog.h
//  YICTMagazine
//
//  Created by LaiZhaowu on 13-10-8.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MagazineCatalog : NSObject

@property (nonatomic, retain) NSNumber *magazineCatalogId;
@property (nonatomic, retain) NSNumber *magazineId;
@property (nonatomic, retain) NSNumber *magazineImageId;
@property (nonatomic, retain) NSString *title;

- (id)initWithAttributes:(NSNumber*)magazineCatalogId
              magazineId:(NSNumber*)magazineId
         magazineImageId:(NSNumber*)magazineImageId
                   title:(NSString*)title;

@end
