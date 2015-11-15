//
//  MagazineCatalog.m
//  YICTMagazine
//
//  Created by LaiZhaowu on 13-10-8.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "MagazineCatalog.h"

@implementation MagazineCatalog

- (id)initWithAttributes:(NSNumber*)magazineCatalogId
              magazineId:(NSNumber*)magazineId
         magazineImageId:(NSNumber*)magazineImageId
                   title:(NSString*)title
{
    _magazineCatalogId = magazineCatalogId;
    _magazineId = magazineId;
    _magazineImageId = magazineImageId;
    _title = title;
    return self;
}

@end
