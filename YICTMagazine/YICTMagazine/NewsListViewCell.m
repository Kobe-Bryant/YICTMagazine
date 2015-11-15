//
//  NewsListViewCell.m
//  YICTMagazine
//
//  Created by Seven on 13-9-6.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "NewsListViewCell.h"
#import "News.h"

@implementation NewsListViewCell

@synthesize imageView;
@synthesize image, title, dateString, category;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setImage:(UIImage *)imageValue
//{
//    if (![imageValue isEqual:image])
//    {
////        image = [imageValue copy];
//        self.imageView.image = imageValue;
//    }
//}

- (void)setTitle:(NSString *)titleValue
{
    if (![titleValue isEqualToString:title])
    {
//        title = [titleValue copy];
        self.titleLabel.text = titleValue;
    }
}

- (void)setDateString:(NSString *)dateStringValue
{
    if (![dateStringValue isEqualToString:dateString])
    {
//        dateString = [dateStringValue copy];
        self.dateLabel.text = dateStringValue;
    }
}

- (void)setCategory:(NSString *)categoryValue
{
    if (![categoryValue isEqualToString:category])
    {
//        category = [categoryValue copy];
        self.categoryLabel.text = categoryValue;
    }
}

@end
