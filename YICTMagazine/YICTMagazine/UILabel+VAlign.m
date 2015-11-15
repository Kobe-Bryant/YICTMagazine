//
//  UILabel+VAlign.m
//  YICTMagazine
//
//  Created by LaiZhaowu on 13-10-4.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "UILabel+VAlign.h"

@implementation UILabel (VAlign)

- (void) setVerticalAlignmentTop
{
    CGSize textSize = [self.text sizeWithFont:self.font
                            constrainedToSize:self.frame.size
                                lineBreakMode:self.lineBreakMode];
    
    CGRect textRect = CGRectMake(self.frame.origin.x,
                                 self.frame.origin.y,
                                 self.frame.size.width,
                                 textSize.height);
    [self setFrame:textRect];
    [self setNeedsDisplay];
}

@end