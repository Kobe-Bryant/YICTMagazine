//
//  NewsListViewCell.h
//  YICTMagazine
//
//  Created by Seven on 13-9-6.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsListViewCell : UITableViewCell

//@property (nonatomic, copy) id dataObject;

//- (void)setDataObject:(id)_dataObject;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UIImageView *categoryImageView;
@property (nonatomic, strong) IBOutlet UILabel *categoryLabel;

@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *category;

@end
