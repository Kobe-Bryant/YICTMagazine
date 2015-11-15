//
//  NewsGalleryImageScrollViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-21.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kImageWidth_Portrait 320.0
#define kImageWidth_Landscape 416.0
#define kImageHeight_Protrait 214.0
#define kImageHeight_Landscape 277.0

#import "NewsGalleryImageScrollViewController.h"
#import "AppDelegate.h"
#import "NewsImage.h"
#import "UILabel+VAlign.h"
#import "DACircularProgressView.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface NewsGalleryImageScrollViewController ()

@end

@implementation NewsGalleryImageScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithFrame:(CGRect)rect dataObject:(id)dataObject selectedIndex:(NSUInteger)selectedIndex
{
    self = [super init];
	if (self)
    {
        _rect = rect;
        _dataObject = dataObject;
        _selectedIndex = selectedIndex;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor greenColor];
    
    
    
	// Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0.0f, 0.0f, _rect.size.width, _rect.size.height);

    
    
    NSArray *newsImageArray = _dataObject;
     NSUInteger pageCount = [newsImageArray count];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0.0f, 0.0f, _rect.size.width, _rect.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_rect.size.width * pageCount, _rect.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * _selectedIndex, 0.0);
//    _scrollView.backgroundColor = [UIColor yellowColor];
//    dispatch_queue_t newsImageQueue = dispatch_queue_create("NewsGalleryImage", NULL);
    
    for (int i = 0; i < pageCount; i++)
    {
        UIView *contentView = [[UIView alloc] init];
        contentView.frame = CGRectMake(_rect.size.width * i,
                                       0.0f,
                                       _rect.size.width,
                                       _rect.size.height);

        NewsImage *newsImage = (NewsImage*)[newsImageArray objectAtIndex:i];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = YES;
        imgView.frame = CGRectMake(0.0f,
                                   (_rect.size.height - 44.0 - kImageHeight_Protrait) / 2,
                                   kImageWidth_Portrait,
                                   kImageHeight_Protrait);
        imgView.backgroundColor = [UIColor lightGrayColor];
        
        DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
        progressView.center = CGPointMake(imgView.frame.size.width / 2.0,
                                          imgView.frame.size.height / 2.0);
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
        
        
//        // Lactivity indicator view
//        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
//                                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        activityIndicatorView.frame = CGRectMake(0.0f,
//                                                 0.0f,
//                                                 imgView.frame.size.width,
//                                                 imgView.frame.size.height);
//        activityIndicatorView.center = CGPointMake(imgView.frame.size.width / 2,
//                                                   imgView.frame.size.height / 2);
//        [activityIndicatorView startAnimating];
//        [imgView addSubview:activityIndicatorView];
//        
//        dispatch_async(newsImageQueue, ^{
//            if (newsImage.imageUrlString != nil && [newsImage.imageUrlString length] > 0)
//            {
//                UIImage *image = [UIImage imageWithData:[newsImage downloadImage]];
//                if (image != nil)
//                {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        imgView.image = image;
//                        [activityIndicatorView stopAnimating];
//                    });
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [newsImage saveImage];
//                    });
//                }
//                else
//                {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [activityIndicatorView stopAnimating];
//                    });
//                }
//            }
//            else
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [activityIndicatorView stopAnimating];
//                });
//            }
//        });

        [contentView addSubview:imgView];
        [contentView setTag:i];
        

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(10.0f,
                                      imgView.frame.origin.y + imgView.frame.size.height + 7.0,
                                      _rect.size.width - 20.0f,
                                      _rect.size.height - (imgView.frame.origin.y + imgView.frame.size.height + 14.0));
        //        titleLabel.alpha = 0;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:12.0];
        //        titleLabel.backgroundColor = nil;
        titleLabel.backgroundColor = [UIColor clearColor];
        
//        titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.numberOfLines = 0;
        titleLabel.text = newsImage.title;
//        [titleLabel setVerticalAlignmentTop];
        [titleLabel sizeToFit];
        [contentView addSubview:titleLabel];

        
        [_scrollView addSubview:contentView];
    }
    
    [self.view addSubview:_scrollView];
//	float pageControlWidth = pageCount * 10.0f + 50.f;
//	float pagecontrolHeight = 20.0f;
//    CGRect pageRect = CGRectMake((_rect.size.width - pageControlWidth) / 2,
//                                 _rect.size.height - pagecontrolHeight,
//                                 pageControlWidth,
//                                 pagecontrolHeight);
    _pageControl = [[UIPageControl alloc] init];
	_pageControl.currentPage = _selectedIndex;
	_pageControl.numberOfPages = pageCount;
    _pageControl.hidden = YES;
//    //	[_pageControl setUserInteractionEnabled:NO];
	[self.view addSubview:_pageControl];
    
    
//    if (_selectedIndex > 0)
//    {
//        _scrollView.contentOffset = CGPointMake(_rect.size.width * _pageControl.currentPage, 0.0);
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    _selectedIndex = ceil(_scrollView.contentOffset.x / pageWidth);
    _pageControl.currentPage = _selectedIndex;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
}

- (void)reloadView
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation))
    {
        _scrollView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * _pageControl.numberOfPages, self.view.frame.size.height);
        _scrollView.contentOffset = CGPointMake(self.view.frame.size.width * _pageControl.currentPage, 0.0);
        for (int i = 0; i < [_scrollView.subviews count]; i++)
        {
            UIView *contentView = [_scrollView.subviews objectAtIndex:i];
            contentView.frame = CGRectMake(self.view.frame.size.width * i,
                                           0.0,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height);
            
            UIImageView *imageView = [contentView.subviews objectAtIndex:0];
            imageView.frame = CGRectMake(0.0,
                                         (self.view.frame.size.height - kImageHeight_Protrait) / 2,
                                         kImageWidth_Portrait,
                                         kImageHeight_Protrait);
            
            UILabel *titleLabel = [contentView.subviews objectAtIndex:1];
            titleLabel.frame = CGRectMake(imageView.frame.origin.x + 10.0,
                                          imageView.frame.origin.y + imageView.frame.size.height + 7.0,
                                          kImageWidth_Portrait - 10.0 * 2,
                                          self.view.frame.size.height - (imageView.frame.origin.y + imageView.frame.size.height + 14.0));
//            titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//            titleLabel.numberOfLines = 0;
            [titleLabel sizeToFit];
        }
        
    }
    else if (UIDeviceOrientationIsLandscape(orientation))
    {
        _scrollView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * _pageControl.numberOfPages, self.view.frame.size.height);
        _scrollView.contentOffset = CGPointMake(self.view.frame.size.width * _pageControl.currentPage, 0.0);
        for (int i = 0; i < [_scrollView.subviews count]; i++)
        {
            UIView *contentView = [_scrollView.subviews objectAtIndex:i];
            contentView.frame = CGRectMake(self.view.frame.size.width * i,
                                           0.0,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height);
            
            UIImageView *imageView = [contentView.subviews objectAtIndex:0];
            imageView.frame = CGRectMake((self.view.frame.size.width - kImageWidth_Landscape) / 2,
                                         0.0,
                                         kImageWidth_Landscape,
                                         kImageHeight_Landscape);

            UILabel *titleLabel = [contentView.subviews objectAtIndex:1];
            titleLabel.frame = CGRectMake(imageView.frame.origin.x + 10.0,
                                          imageView.frame.origin.y + imageView.frame.size.height + 7.0,
                                          kImageWidth_Landscape - 10.0 * 2,
                                          self.view.frame.size.height - (imageView.frame.origin.y + imageView.frame.size.height + 14.0));
//            titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//            titleLabel.numberOfLines = 0;
//            [titleLabel sizeToFit];
        }
        
    }
}



@end
