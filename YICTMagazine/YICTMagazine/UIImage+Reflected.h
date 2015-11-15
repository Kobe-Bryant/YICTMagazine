//
//  UIImage+Reflected.h
//  YICTMagazine
//
//  Created by Seven on 13-8-22.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Reflected)

+ (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height;

@end
