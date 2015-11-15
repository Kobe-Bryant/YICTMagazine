//
//  NewsDetailsViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-20.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kBannerHeight 214.0
#define kTitleLabelX 10.0
#define kTitleLabelHeight 60.0
#define kDateX 30.0
#define kDateY 8.0
#define kDateHeight 20.0
#define kCategoryTagX (kDateX+90.0)
#define kCategoryTagY 13.0
#define kCategoryLabelX (kCategoryTagX+17.0)
#define kDetailsX kTitleLabelX
#define kDetailsY 13.0

#import "NewsDetailsViewController.h"
#import "NewsGalleryViewController.h"
#import "AppDelegate.h"
#import "DACircularProgressView.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface NewsDetailsViewController ()

@end

@implementation NewsDetailsViewController

@synthesize dataObject;
@synthesize selectedIndex;

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
    self.title = NSLocalizedString(@"News", nil);
    self.view.backgroundColor = [UIColor whiteColor];

    
    
    // Navigation bar back button
    UIImage *backButtonImage = [UIImage imageNamed:@"Back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    
    // Navigation bar share button
    UIImage *shareButtonImage = [UIImage imageNamed:@"Share.png"];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:shareButtonImage forState:UIControlStateNormal];
    [shareButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = shareBarItem;

    
    
    // Main frame
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake(0.0f,
                                       0.0f,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height);
    [self.view addSubview:_mainScrollView];

    
    
    // News
    NSNumber *newsId = self.dataObject;
    Result *result = [News getDetail:newsId];
    if (result.isSuccess && result.data != nil)
    {
        self.news = result.data;
        self.title = self.news.title;
        
        // Banner
        UIView *bannerView = [[UIView alloc] init];
        if ([self.news.images count] > 0)
        {
            bannerView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, kBannerHeight);
            newsBannerScrollViewController = [[NewsBannerScrollViewController alloc] initWithFrame:bannerView.frame
                                                                                        dataObject:self.news.images];
            newsBannerScrollViewController.delegate = self;
            [bannerView addSubview:newsBannerScrollViewController.view];
        }
        [_mainScrollView addSubview:bannerView];
        
        
        // Title
        UILabel *newsTitleLabel = [[UILabel alloc] init];
        newsTitleLabel.frame = CGRectMake(kTitleLabelX,
                                          CGRectGetMaxY(bannerView.frame),
                                          self.view.bounds.size.width - kTitleLabelX * 2.0,
                                          kTitleLabelHeight);
        newsTitleLabel.textColor = [UIColor colorWithRed:(51.0 / 255.0)
                                                   green:(51.0 / 255.0)
                                                    blue:(51.0 / 255.0)
                                                   alpha:1.0];
        newsTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        newsTitleLabel.numberOfLines = 0;
        newsTitleLabel.text = self.news.title;
        [_mainScrollView addSubview:newsTitleLabel];
        
        
        // Date
        UIImage *clockCellImage = [UIImage imageNamed:@"NewsDetailsClockBackground.png"];
        UIImageView *clockCellImageView = [[UIImageView alloc] initWithImage:clockCellImage];
        clockCellImageView.frame = CGRectMake(0.0,
                                              CGRectGetMaxY(newsTitleLabel.frame),
                                              clockCellImage.size.width,
                                              clockCellImage.size.height);
        [_mainScrollView addSubview:clockCellImageView];
        
        UILabel *newsDateLabel = [[UILabel alloc] init];
        newsDateLabel.frame = CGRectMake(kDateX,
                                         CGRectGetMaxY(newsTitleLabel.frame) + kDateY,
                                         self.view.bounds.size.width - kDateX * 2.0,
                                         kDateHeight);
        newsDateLabel.font = [UIFont systemFontOfSize:12.0];
        newsDateLabel.textColor = [UIColor colorWithRed:(170.0 / 255.0)
                                                  green:(170.0 / 255.0)
                                                   blue:(170.0 / 255.0)
                                                  alpha:1.0];
        newsDateLabel.text = self.news.releaseDate;
        [_mainScrollView addSubview:newsDateLabel];
        
        
        // Category
        UIImage *tagImage = [UIImage imageNamed:@"NewsCategoryTag.png"];
        UIImageView *tagImageView = [[UIImageView alloc] initWithImage:tagImage];
        tagImageView.frame = CGRectMake(kCategoryTagX,
                                        CGRectGetMaxY(newsTitleLabel.frame) + kCategoryTagY,
                                        tagImage.size.width,
                                        tagImage.size.height);
        if (self.news.categoryName == nil || (self.news.categoryName != nil && [self.news.categoryName length] == 0))
        {
            tagImageView.hidden = YES;
        }
        [_mainScrollView addSubview:tagImageView];
        
        UILabel *categoryLabel = [[UILabel alloc] init];
        categoryLabel.frame = CGRectMake(kCategoryLabelX,
                                         newsDateLabel.frame.origin.y,
                                         self.view.bounds.size.width - kCategoryLabelX - kDateX,
                                         newsDateLabel.frame.size.height);
        categoryLabel.font = [UIFont systemFontOfSize:12.0];
        categoryLabel.textColor = [UIColor colorWithRed:(170.0 / 255.0)
                                                  green:(170.0 / 255.0)
                                                   blue:(170.0 / 255.0)
                                                  alpha:1.0];
        categoryLabel.text = self.news.categoryName;
        [_mainScrollView addSubview:categoryLabel];
        
        
        // Content
        UILabel *newsDetailsLabel = [[UILabel alloc] init];
        CGRect newsDetailsRect = CGRectMake(kDetailsX,
                                            CGRectGetMaxY(clockCellImageView.frame) + kDetailsY,
                                            self.view.bounds.size.width - kDetailsX * 2.0,
                                            self.view.bounds.size.height);
        newsDetailsLabel.frame = newsDetailsRect;
        newsDetailsLabel.textColor = [UIColor colorWithRed:(102.0 / 255.0)
                                                     green:(102.0 / 255.0)
                                                      blue:(102.0 / 255.0)
                                                     alpha:1.0];
        newsDetailsLabel.font = [UIFont systemFontOfSize:15.0];
        newsDetailsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        newsDetailsLabel.numberOfLines = 0;
        newsDetailsLabel.text = self.news.contents;
        [newsDetailsLabel sizeToFit];
        [_mainScrollView addSubview:newsDetailsLabel];
        
        CGSize size = _mainScrollView.frame.size;
        size.height = CGRectGetMaxY(newsDetailsLabel.frame) + 100.0;
        [_mainScrollView setContentSize:size];
        

         //        UIWebView *webView = [[UIWebView alloc] init];
//        webView.frame = CGRectMake(kDetailsX,
//                                   kDetailsY,
//                                   self.view.frame.size.width - kDetailsYDiff, 200.0f);
//        webView.delegate = self;
//        webView.scrollView.scrollEnabled = NO;
//        NSString *contents = [[NSString alloc] init];
//        contents = [contents stringByAppendingString:@"<style type=\"text/css\">\n"];
//        contents = [contents stringByAppendingString:@"body { color: rgb(102, 102, 102); }\n"];
//        contents = [contents stringByAppendingString:@"</style>\n"];
//        contents = [contents stringByAppendingString:self.news.contents];
//        [webView loadHTMLString:contents baseURL:nil];
//        [_mainScrollView addSubview:webView];
    }
    else
    {
        _currentError = result.error;
    }
    
    
    
    // Error
    if (_currentError != nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString((_currentError.code == 200 ? @"Warning" : @"Error"), nil)
                                                            message:[_currentError.userInfo objectForKey:NSLocalizedDescriptionKey]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    _mainScrollView.frame = CGRectMake(0.0f,
                                       0.0f,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height);
    
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    NSLog(@"UIDeviceOrientatio nIsLandscape %i", UIDeviceOrientationIsLandscape(orientation));
    if (UIDeviceOrientationIsLandscape(orientation))
    {
        [self willRotateToInterfaceOrientation:UIInterfaceOrientationPortrait duration:0.1];
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
//
//        if (orientation == UIDeviceOrientationLandscapeLeft)
//        {
//            NSLog(@"UIDeviceOrientationLandscapeLeft");
//            [self.navigationController.view setTransform:CGAffineTransformMakeRotation(M_PI / -2.0)];
//        }
//        else
//        {
//            NSLog(@"UIDeviceOrientationLandscapeRIGHT");
//            
////            [self.view setTransform:CGAffineTransformMakeRotation(M_PI)];
//            
//        }
    }
    else
    {
//        NSLog(@"NO");
    }

//    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
//    if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
//    {
//        [self willRotateToInterfaceOrientation:UIInterfaceOrientationPortrait duration:0.25];
//        [self didRotateFromInterfaceOrientation:UIInterfaceOrientationPortrait];
//    }
    
//    else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
//        [self.view setTransform:CGAffineTransformMakeRotation(M_PI)];
//    } else if (orientation == UIDeviceOrientationPortrait) {
//        [self.view setTransform:CGAffineTransformMakeRotation(0.0)];
//    }
//    if (toorientation == UIInterfaceOrientationPortrait) {
//        sub_view.transform = CGAffineTransformMakeRotation(degreesToRadin(0));
//    }
//    else if (toorientation == UIInterfaceOrientationPortraitUpsideDown){
//        sub_view.transform = CGAffineTransformMakeRotation(degreesToRadin(180));
//    }
//    else if (toorientation == UIInterfaceOrientationLandscapeLeft){
//        sub_view.transform = CGAffineTransformMakeRotation(degreesToRadin(-90));
//    }
//    else if (toorientation == UIInterfaceOrientationLandscapeRight){
//        sub_view.transform = CGAffineTransformMakeRotation(degreesToRadin(90));
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    self.dataObject = nil;
//    _news = nil;
}

- (BOOL)shouldAutorotate
{
    return NO;
//    return UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation]);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
//}


//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}

- (void)back
{
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)share
{
    if (self.news != nil)
    {
        NSMutableArray *activityItems = [[NSMutableArray alloc] init];
        if (self.news.title != nil)
        {
            [activityItems addObject:self.news.title];
        }
        if (self.news.summary != nil)
        {
            [activityItems addObject:self.news.summary];
        }
        if (self.news.coverImageUrlString != nil)
        {
            UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.news.thumbImageUrlString];
            if (cacheImage != nil)
            {
                [activityItems addObject:cacheImage];
            }
        }
        NSMutableArray *applicationActivities = [[NSMutableArray alloc] init];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                initWithActivityItems:activityItems
                                                applicationActivities:applicationActivities];
        activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact,
                                             UIActivityTypePostToWeibo,
                                             UIActivityTypeSaveToCameraRoll,
                                             UIActivityTypeCopyToPasteboard,
                                             UIActivityTypePrint];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

- (void)newsBannerImagePressed:(UIPageControl *)pageControl
{
    NewsGalleryViewController *newsGalleryVC = [[NewsGalleryViewController alloc] init];
    newsGalleryVC.dataObject = self.news.images;
    newsGalleryVC.selectedIndex = pageControl.currentPage;
    [self.navigationController pushViewController:newsGalleryVC animated:YES];
}

@end
