//
//  MagazineImage.m
//  YICTMagazine
//
//  Created by Seven on 13-8-23.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "MagazineImage.h"
#import "AppDelegate.h"

@implementation MagazineImage

- (id)initWithAttributes:(NSNumber*)magazineImageId
              magazineId:(NSNumber*)magazineId
                   title:(NSString*)title
     thumbImageUrlString:(NSString *)thumbImageUrlString
      origImageUrlString:(NSString *)origImageUrlString
{
    _magazineImageId = magazineImageId;
    _magazineId = magazineId;
    _title = title;
    _thumbImageUrlString = thumbImageUrlString;
    _origImageUrlString = origImageUrlString;
    return self;
}

@end
