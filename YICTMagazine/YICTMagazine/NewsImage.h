//
//  NewsImage.h
//  YICTMagazine
//
//  Created by Seven on 13-8-21.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsImage : NSObject

@property (nonatomic, retain) NSNumber *newsImageId;
@property (nonatomic, retain) NSNumber *newsId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *imageUrlString;
@property (nonatomic, readwrite) BOOL hasUpdated;

- (id)initWithAttributes:(NSNumber*)newsImageId
                  newsId:(NSNumber*)newsId
                   title:(NSString*)title
          imageUrlString:(NSString*)imageUrlString;

@end
