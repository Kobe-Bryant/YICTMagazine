//
//  Magazine.h
//  YICTMagazine
//
//  Created by Seven on 13-8-21.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MagazineImage.h"
#import "MagazineCatalog.h"
#import "Result.h"

@interface Magazine : NSObject

@property (nonatomic, retain) NSNumber *magazineId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *coverImageUrlString;
@property (nonatomic, retain) NSDate *updateDate;
@property (nonatomic, retain) NSString *pdfFileUrlString;
@property (nonatomic, readwrite) double pdfFileSize;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, readwrite) BOOL isNew;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableArray *catalogs;
@property (nonatomic, readwrite) NSUInteger updateTimeStamp;
@property (nonatomic, readwrite) BOOL hasUpdated;
@property (nonatomic, readwrite) BOOL hasDownloaded;

- (id)initWithAttributes:(NSNumber*)magazineId
                   title:(NSString*)title
     coverImageUrlString:(NSString*)coverImageUrlString
         updateTimeStamp:(NSUInteger)updateTimeStamp;

+ (Result*)getList:(BOOL)isDisplayAtHomeView
             isNew:(BOOL)isNew
            offset:(NSUInteger)offset
             limit:(NSUInteger)limit;

+ (Result*)getDetail:(NSNumber*)magazineId;

- (void)refreshDownloadStatus;

@end
