//
//  ImageScrollViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-15.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kBannerHeight 214.0f

#import "NewsBannerScrollViewController.h"
#import "News.h"
#import "AppDelegate.h"
#import "DACircularProgressView.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface NewsBannerScrollViewController ()

@end

@implementation NewsBannerScrollViewController

@synthesize delegate;

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
    [self.view setFrame:_rect];
    
    
    
//    self.view.backgroundColor = [UIColor clearColor];
    NSArray *newsImageArray = _dataObject;
    NSUInteger pageCount = [newsImageArray count];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f,
                                                                0.0f,
                                                                _rect.size.width,
                                                                _rect.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_rect.size.width * pageCount, _rect.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;

    for (int i = 0; i < pageCount; i++)
    {
        NewsImage *newsImage = [newsImageArray objectAtIndex:i];
		UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(_rect.size.width * i,
                                   0.0f,
                                   _rect.size.width,
                                   _rect.size.height);
        imgView.backgroundColor = [UIColor lightGrayColor];
        imgView.userInteractionEnabled = YES;
        
        DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
        progressView.center = CGPointMake(imgView.frame.size.width / 2.0,
                                          imgView.frame.size.height / 2.0) ;
        [imgView addSubview:progressView];
        
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:newsImage.imageUrlString] options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
            [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (finished)
            {
                [progressView setProgress:1.0 animated:YES];                
                imgView.image = image;
                [progressView removeFromSuperview];
            }
        }];


        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(pressed:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
		[imgView addGestureRecognizer:tap];
        
		[_scrollView addSubview:imgView];
	}
    [self.view addSubview:_scrollView];
//    dispatch_release(newsImageQueue);
    
    
	float pageControlWidth = pageCount * 10.0f + 50.f;
	float pagecontrolHeight = 20.0f;
    CGRect pageRect = CGRectMake((_rect.size.width - pageControlWidth) / 2, _rect.size.height - pagecontrolHeight, pageControlWidth, pagecontrolHeight);
    _pageControl = [[UIPageControl alloc]initWithFrame:pageRect];
    if ([_pageControl respondsToSelector:@selector(pageIndicatorTintColor)] == YES)
    {
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
    }
	_pageControl.currentPage = 1;
	_pageControl.numberOfPages = pageCount;
	[_pageControl setUserInteractionEnabled:NO];
    if ([newsImageArray count] < 2)
    {
        _pageControl.hidden = YES;
    }
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

- (void)pressed:(UITapGestureRecognizer *)sender
{
    [self.delegate newsBannerImagePressed:_pageControl];
}

@end
