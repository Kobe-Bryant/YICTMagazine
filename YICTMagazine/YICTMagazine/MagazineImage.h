//
//  MagazineImage.h
//  YICTMagazine
//
//  Created by Seven on 13-8-23.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MagazineImage : NSObject

@property (nonatomic, retain) NSNumber *magazineImageId;
@property (nonatomic, retain) NSNumber *magazineId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *thumbImageUrlString;
@property (nonatomic, retain) NSString *origImageUrlString;
@property (nonatomic, readwrite) BOOL hasUpdated;

- (id)initWithAttributes:(NSNumber*)magazineImageId
              magazineId:(NSNumber*)magazineId
                   title:(NSString*)title
     thumbImageUrlString:(NSString*)thumbImageUrlString
      origImageUrlString:(NSString*)origImageUrlString;

@end
