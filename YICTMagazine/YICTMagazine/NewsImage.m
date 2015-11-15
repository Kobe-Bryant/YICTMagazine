//
//  NewsImage.m
//  YICTMagazine
//
//  Created by Seven on 13-8-21.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "NewsImage.h"
#import "AppDelegate.h"

@implementation NewsImage

- (id)initWithAttributes:(NSNumber*)newsImageId
                  newsId:(NSNumber*)newsId
                   title:(NSString*)title
          imageUrlString:(NSString*)imageUrlString{
    _newsImageId = newsImageId;
    _newsId = newsId;
    _title = title;
    _imageUrlString = imageUrlString;
    return self;
}

@end
