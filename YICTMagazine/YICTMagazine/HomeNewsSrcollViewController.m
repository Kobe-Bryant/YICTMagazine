//
//  HomeNewsScollViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-30.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kBannerHeight 181.f
#define kNewsTitleX 10.0f
#define kNewsTitleY kBannerHeight+9.0f
#define kNewsTitleYDiff 20.f
#define kNewsTitleHeight 48.0f
#define kNewsSummaryY kNewsTitleY+kNewsTitleHeight+7.0f
#define kNewsSummaryHeight 74.0f
#define kNewsClockY kNewsSummaryY+kNewsSummaryHeight-7.0f

#import "HomeNewsSrcollViewController.h"
#import "TapGestureRecognizer.h"
#import "News.h"
#import "AppDelegate.h"
#import "DACircularProgressView.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface HomeNewsScrollViewController ()

@end

@implementation HomeNewsScrollViewController

@synthesize _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithFrame:(CGRect)rect dataObject:(id)dataObject
{
    self = [super init];
    if (self)
    {
        _rect = rect;
        _dataObject = dataObject;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.frame = _rect;
//    self.view.backgroundColor = [UIColor whiteColor];

    NSArray *newsList = _dataObject;
    NSUInteger pageCount = [newsList count];
    // _scrollView = [[UIScrollView alloc] initWithFrame:_rect];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0.0f, 0.0f, _rect.size.width, _rect.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_rect.size.width * pageCount, _rect.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];

    for (int i = 0; i < pageCount; i++)
    {
        UIView *contentView = [[UIView alloc] init];
        contentView.frame = CGRectMake(_rect.size.width * i,
                                       0.0f,
                                       _rect.size.width,
                                       _rect.size.height);
        contentView.tag = i;
        

        // Image
        News *news = [newsList objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0.0f, 0.0f, _rect.size.width, kBannerHeight);
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.userInteractionEnabled = YES;
        
        DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
        progressView.center = imageView.center;
        [imageView addSubview:progressView];
        
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:news.coverImageUrlString] options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
            [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (finished)
            {
                [progressView setProgress:1.0 animated:YES];                
                imageView.image = image;
                [progressView removeFromSuperview];
            }
        }];

        
		TapGestureRecognizer *imageTap = [[TapGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
        imageTap.numberOfTapsRequired = 1;
        imageTap.numberOfTouchesRequired = 1;
        imageTap.dataObject = news.newsId;
		[imageView addGestureRecognizer:imageTap];
        
        [contentView addSubview:imageView];
        
        // Title
        UILabel *newsTitleLabel = [[UILabel alloc] init];
        newsTitleLabel.frame = CGRectMake(kNewsTitleX,
                                          kNewsTitleY,
                                          self.view.frame.size.width - kNewsTitleYDiff,
                                          kNewsTitleHeight);
        newsTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        newsTitleLabel.numberOfLines = 2;
        newsTitleLabel.font = [UIFont systemFontOfSize:18.0];
        newsTitleLabel.textColor = [UIColor colorWithRed:(51.0 / 255.0)
                                                   green:(51.0 / 255.0)
                                                    blue:(51.0 / 255.0)
                                                   alpha:1.0];
        newsTitleLabel.text = news.title;
        
        TapGestureRecognizer *titleTap = [[TapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(pressed:)];
        titleTap.numberOfTapsRequired = 1;
        titleTap.numberOfTouchesRequired = 1;
        titleTap.dataObject = news.newsId;
        [newsTitleLabel addGestureRecognizer:titleTap];
        newsTitleLabel.userInteractionEnabled = YES;
        
        [contentView addSubview:newsTitleLabel];
        
        if ([[UIScreen mainScreen] scale] == 2.0f
            && [[UIScreen mainScreen] bounds].size.height == 568.0f)
        {
            // Summary
            UILabel *newsSummaryLabel = [[UILabel alloc] init];
            newsSummaryLabel.frame = CGRectMake(kNewsTitleX,
                                            kNewsSummaryY,
                                            self.view.frame.size.width - kNewsTitleYDiff,
                                            kNewsSummaryHeight);
            newsSummaryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            newsSummaryLabel.numberOfLines = 3;
            newsSummaryLabel.font = [UIFont systemFontOfSize:14.0];
            newsSummaryLabel.textColor = [UIColor grayColor];
            newsSummaryLabel.text = news.summary;
            [newsSummaryLabel sizeToFit];
        
            TapGestureRecognizer *summaryTap = [[TapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(pressed:)];
            summaryTap.numberOfTapsRequired = 1;
            summaryTap.numberOfTouchesRequired = 1;
            summaryTap.dataObject = news.newsId;
            [newsSummaryLabel addGestureRecognizer:summaryTap];
            newsSummaryLabel.userInteractionEnabled = YES;
        
            [contentView addSubview:newsSummaryLabel];
            
            //  Date
//            UIImage *clockCellImage = [UIImage imageNamed:@"ClockCell2.png"];
//            UIImageView *clockCellImageView = [[UIImageView alloc] initWithImage:clockCellImage];
//            clockCellImageView.frame = CGRectMake(0.0f,
//                                                  kNewsClockY,
//                                                  clockCellImage.size.width,
//                                                  clockCellImage.size.height);
//            
//            clockCellImageView.backgroundColor = [UIColor
//                                                  colorWithRed:(236.0f / 255.0f)
//                                                  green:(236.0f / 255.0f)
//                                                  blue:(236.0f / 255.0f)
//                                                  alpha:1.0f];
//            [contentView addSubview:clockCellImageView];
        }
        
		[_scrollView addSubview:contentView];
	}
    [self.view addSubview:_scrollView];
    
	
    
    if ([[UIScreen mainScreen] scale] == 2.0f
        && [[UIScreen mainScreen] bounds].size.height == 568.0f)
    {
        UIImage *clockCellImage = [UIImage imageNamed:@"ClockCell2.png"];
        UIImageView *clockCellImageView = [[UIImageView alloc] initWithImage:clockCellImage];
        clockCellImageView.frame = CGRectMake(0.0f,
                                              self.view.frame.size.height - clockCellImage.size.height + 1.0f,
                                              clockCellImage.size.width,
                                              clockCellImage.size.height);
        [self.view addSubview:clockCellImageView];
    }
    
    
    float pageControlWidth = pageCount * 10.0f + 50.f;
	float pageControlHeight = 20.0f;
    float pageControlX = (_rect.size.width - pageControlWidth) / 2;
    float pageControlY = _rect.size.height - pageControlHeight;
    if ([[UIScreen mainScreen] scale] == 2.0f
        && [[UIScreen mainScreen] bounds].size.height == 568.0f)
    {
        pageControlY -= 9.0f;
    }
    else
    {
        pageControlY -= 4.0f;
    }
    CGRect pageRect = CGRectMake(pageControlX,
                                 pageControlY,
                                 pageControlWidth,
                                 pageControlHeight);
    _pageControl = [[UIPageControl alloc]initWithFrame:pageRect];
    if ([_pageControl respondsToSelector:@selector(pageIndicatorTintColor)] == YES)
    {
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    if ([_pageControl respondsToSelector:@selector(currentPageIndicatorTintColor)] == YES)
    {
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    }
	_pageControl.currentPage = 1;
	_pageControl.numberOfPages = pageCount;
	[_pageControl setUserInteractionEnabled:NO];
	[self.view addSubview:_pageControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

- (void)pressed:(TapGestureRecognizer *)sender
{
    [self._delegate newsViewPressed:sender.dataObject];
}

@end
