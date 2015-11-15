//
//  MagazineDetailsViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-22.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "AppDelegate.h"
#import "MagazineDetailsViewController.h"
#import "MagazineTabBarViewController.h"
#import "Magazine.h"

@interface MagazineDetailsViewController ()

@property (nonatomic, retain) UIButton *viewButton;
@property (nonatomic, retain) UIButton *downloadButton;

@end

@implementation MagazineDetailsViewController

@synthesize dataObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Title
    self.title = NSLocalizedString(@"Issue", nil);

    
    
    // Navigation bar back button
    UIImage *backButtonImage = [UIImage imageNamed:@"Back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = customBarItem;

    
    
    // Background
    UIImage *backgroudImage = [UIImage imageNamed:@"Background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroudImage];

    
    
    // Magazine
//    Magazine *magazine = [[Magazine alloc] initWithAttributes:@1 title:@"The Quay Issue 15" coverImageUrlString:@"Magazine1.png" updateDate:[[NSDate alloc] initWithTimeIntervalSince1970:1377509909] pdfFileUrlString:nil pdfFileSize:100000 summary:@"On 29 July 2013, YICT together with Yantian Port Group, and Shenzhen Agriculture and Fishery Bureau released over 3.8 million fingerlings into the waters of Yantian Port." isNew:NO isDownloaded:NO isUpdated:NO];
    Magazine *magazine = nil;
    
    UIView *magazineView = [[UIView alloc] init];
    magazineView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 217.0f);
    
    UIImage *scrollViewBackgroundImage = [UIImage imageNamed:@"MagazineListBackground.png"];
    UIImageView *scrollViewBackgroundImageView = [[UIImageView alloc] initWithImage:scrollViewBackgroundImage];
    scrollViewBackgroundImageView.frame = CGRectMake(0.0f,
                                                     0.0f,
                                                     scrollViewBackgroundImage.size.width,
                                                     scrollViewBackgroundImage.size.height);
    scrollViewBackgroundImageView.backgroundColor = [UIColor clearColor];
    [magazineView addSubview:scrollViewBackgroundImageView];
    
    UIImage *shelfImage = [UIImage imageNamed:@"MagazineShelf.png"];
    UIImageView *shelfImageView = [[UIImageView alloc] initWithImage:shelfImage];
    shelfImageView.frame = CGRectMake(0.0f,
                                      170.0f,
                                      shelfImage.size.width,
                                      shelfImage.size.height);
    [magazineView addSubview:shelfImageView];
    
    UIImage *magazineBackgroundImage = [UIImage imageNamed:@"MagazinePages.png"];
    UIImageView *magazineBackgroundImageView = [[UIImageView alloc] initWithImage:magazineBackgroundImage];
    magazineBackgroundImageView.frame = CGRectMake(35.0f,
                                                   35.0f,
                                                   magazineBackgroundImage.size.width,
                                                   magazineBackgroundImage.size.height);
    
    UIImage *image = [UIImage imageNamed:magazine.coverImageUrlString];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0.0f,
                                 0.0f,
                                 magazineBackgroundImage.size.width - 4.0f,
                                 magazineBackgroundImage.size.height);
    [magazineBackgroundImageView addSubview:imageView];
    [magazineView addSubview:magazineBackgroundImageView];
    
    UIImage *reflectedBackgroundImage = [UIImage reflectedImage:magazineBackgroundImageView withHeight:7.0f];
    UIImageView *reflectedBackgroundImageView = [[UIImageView alloc] initWithImage:reflectedBackgroundImage];
    reflectedBackgroundImageView.frame = CGRectMake(imageView.frame.size.width,
                                                    imageView.frame.origin.y + imageView.frame.size.height + 1,
                                                    4.0f,
                                                    7.0f);
    reflectedBackgroundImageView.alpha = 0.3f;
    [magazineBackgroundImageView addSubview:reflectedBackgroundImageView];
    
    UIImage *reflectedImage = [UIImage reflectedImage:imageView withHeight:7.0f];
    UIImageView *reflectedImageView = [[UIImageView alloc] initWithImage:reflectedImage];
    reflectedImageView.frame = CGRectMake(imageView.frame.origin.x,
                                          imageView.frame.origin.y + imageView.frame.size.height + 1.0f,
                                          imageView.frame.size.width,
                                          7.0f);
    reflectedImageView.alpha = 0.3f;
    [magazineBackgroundImageView addSubview:reflectedImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(152.0f, 35.0f, 160.0f, 20.0f);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleLabel.text = magazine.title;
    [magazineView addSubview:titleLabel];
    
    UIImage *magazineClockImage = [UIImage imageNamed:@"MagazineClock.png"];
    UIImageView *magazineClockImageView = [[UIImageView alloc] initWithImage:magazineClockImage];
    magazineClockImageView.frame = CGRectMake(152.0f, 80.0f, magazineClockImage.size.width, magazineClockImage.size.height);
    [magazineView addSubview:magazineClockImageView];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.frame = CGRectMake(170.0f, 76.0f, 140.0f, 20.0f);
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont systemFontOfSize:12.0f];
//    dateLabel.text = [[NSString alloc] initWithFormat:@"Update: %@", magazine.updateDateString];
    [magazineView addSubview:dateLabel];
    
    UIImage *magazineBookImage = [UIImage imageNamed:@"MagazineBook.png"];
    UIImageView *magazineBookImageView = [[UIImageView alloc] initWithImage:magazineBookImage];
    magazineBookImageView.frame = CGRectMake(152.0f, 100.0f, magazineBookImage.size.width, magazineBookImage.size.height);
    [magazineView addSubview:magazineBookImageView];
    
    UILabel *sizeLabel = [[UILabel alloc] init];
    sizeLabel.frame = CGRectMake(170.0f, 96.0f, 140.0f, 20.0f);
    sizeLabel.backgroundColor = [UIColor clearColor];
    sizeLabel.textColor = [UIColor whiteColor];
    sizeLabel.font = [UIFont systemFontOfSize:12.0f];
//    sizeLabel.text = [[NSString alloc] initWithFormat:@"Size: %@", magazine.pdfFileSizeString];
    [magazineView addSubview:sizeLabel];
    
    [self.view addSubview:magazineView];
    
    
    
    // Operation button
    UIView *operationView = [[UIView alloc] init];
    operationView.frame = CGRectMake(0.0f,
                                     magazineView.frame.size.height,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
    operationView.backgroundColor = [UIColor
                                     colorWithRed:(236.0f / 255.0f)
                                     green:(236.0f / 255.0f)
                                     blue:(236.0f / 255.0f)
                                     alpha:1.0f];
    
//    UIImage *operationBackgroundImage = [UIImage imageNamed:@"MagazineOperationBackground.png"];
//    UIImageView *operationBackgroundImageView = [[UIImageView alloc] initWithImage:operationBackgroundImage];
//    operationBackgroundImageView.frame = CGRectMake(0.0f,
//                                                    0.0f,
//                                                    operationBackgroundImage.size.width,
//                                                    operationBackgroundImage.size.height);
//    [operationView addSubview:operationBackgroundImageView];
    
    UILabel *summaryLabel = [[UILabel alloc] init];
    summaryLabel.frame = CGRectMake(33.0f,
                                    23.0f,
                                    self.view.frame.size.width - 66.0f,
                                    65.0f);
    summaryLabel.backgroundColor = [UIColor clearColor];
//    summaryLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    summaryLabel.lineBreakMode = NSLineBreakByCharWrapping;
    summaryLabel.numberOfLines = 0;
    summaryLabel.font = [UIFont systemFontOfSize:13.0f];
    summaryLabel.textColor = [UIColor
                              colorWithRed:(102.0f / 255.0f)
                              green:(102.0f / 255.0f)
                              blue:(102.0f / 255.0f)
                              alpha:1.0f];
    summaryLabel.text = magazine.summary;
    [operationView addSubview:summaryLabel];
    
    UIImage *viewBsuttonImage = [UIImage imageNamed:@"ViewButton.png"];
    self.viewButton = [[UIButton alloc] init];
    self.viewButton.frame = CGRectMake((self.view.frame.size.width - viewBsuttonImage.size.width) / 2,
                                  120.0f,
                                  viewBsuttonImage.size.width,
                                  viewBsuttonImage.size.height);
    [self.viewButton setImage:viewBsuttonImage forState:UIControlStateNormal];

    UITapGestureRecognizer *viewButtonTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(viewPressed:)];
    [viewButtonTap setNumberOfTapsRequired:1];
    [viewButtonTap setNumberOfTouchesRequired:1];
    [self.viewButton addGestureRecognizer:viewButtonTap];
    self.viewButton.userInteractionEnabled = YES;
    
    [operationView addSubview:self.viewButton];
    
    
    UIImage *downloadBsuttonImage = [UIImage imageNamed:@"DownloadButton.png"];
    UIButton *downloadButton = [[UIButton alloc] init];
    downloadButton.frame = CGRectMake((self.view.frame.size.width - downloadBsuttonImage.size.width) / 2,
                                      180.0f,
                                      downloadBsuttonImage.size.width,
                                      downloadBsuttonImage.size.height);
    [downloadButton setImage:downloadBsuttonImage forState:UIControlStateNormal];

    UITapGestureRecognizer *downloadButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadPressed:)];
    [downloadButtonTap setNumberOfTapsRequired:1];
    [downloadButtonTap setNumberOfTouchesRequired:1];
    [downloadButton addGestureRecognizer:downloadButtonTap];
    downloadButton.userInteractionEnabled = YES;
    
    [operationView addSubview:downloadButton];
    
    [self.view addSubview:operationView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewPressed:(id)sender
{
    MagazineTabBarViewController *tabBarVC = [[MagazineTabBarViewController alloc] init];
    [self.navigationController pushViewController:tabBarVC animated:YES];
}

- (void)downloadPressed:(id)sender
{
//    NSLog(@"%@", sender);
}

@end
