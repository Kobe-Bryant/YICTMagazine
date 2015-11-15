//
//  MagazineListViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-21.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kRowHeight 166.0f
#define kMagazineContainerHeight 170.0f
#define kMagazineImageWidth 100.0f
#define kMagazineImageHeight 141.0f
#define kReflectedImageHeight 7.0f
#define kLoadingAIVHeight 44.0f
#define kPageSize 20;

#import "MagazineListViewController.h"
#import "AppDelegate.h"
#import "TapGestureRecognizer.h"
#import "Magazine.h"
//#import "MagazineDetailsViewController.h"
#import "MagazineTabBarViewController.h"
#import "UIImage+Reflected.h"
#import "AlertView.h"
#import "DACircularProgressView.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface MagazineListViewController ()

@end

@implementation MagazineListViewController

@synthesize sidebarDelegate, scrollView, loadingAIV;
@synthesize magazineArray, offset, limit, isLoadingData, isEnded;

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
    self.title = NSLocalizedString(@"Magazine", nil);
    
    
    
    // Toggle sidebar button
    UIButton *toggleSidebarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleSidebarButton.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    NSString *toggleSidebarOptionImageName = [NSString stringWithFormat:@"SidebarOptionButton.png"];
    UIImage *toggleSidebarOptionImage = [UIImage imageNamed:toggleSidebarOptionImageName];
    [toggleSidebarButton setImage:toggleSidebarOptionImage forState:UIControlStateNormal];
    [toggleSidebarButton addTarget:self action:@selector(toggleSidebar:)
                  forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sidebarOptionButton = [[UIBarButtonItem alloc]
                                            initWithCustomView:toggleSidebarButton];
    self.navigationItem.leftBarButtonItem = sidebarOptionButton;
    
    

    // Background
    UIImage *backgroudImage = [UIImage imageNamed:@"Background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroudImage];
    
    
    
    // Magazine
    self.offset = 0;
    self.limit = kPageSize;
    Result *result = [Magazine getList:NO isNew:NO offset:self.offset limit:self.limit];
    if (result.isSuccess == NO)
    {
        _currentError = result.error;
    }
    
    magazineArray = result.data;
    scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0.0f,
                                       0.0f,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height);
    self.scrollView.delegate = self;
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self reloadData];
    [self.view addSubview:self.scrollView];
    
    
    
    // Loading
//    UIView *loadingView = [[UIView alloc] init];
//    loadingView.frame = CGRectMake(0.0f,
//                                   self.view.frame.size.height - kLoadingAIVHeight * 2,
//                                   self.view.frame.size.width,
//                                   kLoadingAIVHeight);
    self.loadingAIV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.loadingAIV.frame = CGRectMake(0.0,
                                       self.view.bounds.size.height - kLoadingAIVHeight,
                                       self.view.bounds.size.width,
                                       kLoadingAIVHeight);
//    self.loadingAIV.center = CGPointMake(self.loadingAIV.frame.size.width / 2.0,
//                                         self.loadingAIV.frame.size.height / 2.0);
//    [loadingView addSubview:self.loadingAIV];
    [self.view addSubview:self.loadingAIV];
    
    
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
    [super viewWillAppear:animated];
    self.loadingAIV.frame = CGRectMake(0.0,
                                       self.view.bounds.size.height - kLoadingAIVHeight,
                                       self.view.bounds.size.width,
                                       kLoadingAIVHeight);

    
    if (_isResized == NO)
    {
        self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
        self.scrollView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
        _isResized = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.magazineArray = nil;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)toggleSidebar:(id)sender
{
    [self.sidebarDelegate toggleSidebrButtonPressed:self];
}

- (void)back
{
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressed:(TapGestureRecognizer*)tapGestureRecognizer
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.internetReachability.currentReachabilityStatus != NotReachable
        && appDelegate.wifiReachability.currentReachabilityStatus == NotReachable)
    {
        AlertView *alertView = [[AlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                        message:NSLocalizedString(@"You did not use Wi-Fi connection. Are you sure you want to continue connecting?", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"View", nil)
                                              otherButtonTitles:NSLocalizedString(@"Cancel", nil), nil];
        alertView.dataObject = tapGestureRecognizer.dataObject;
        [alertView show];
    }
    else
    {
        MagazineTabBarViewController *controller = [[MagazineTabBarViewController alloc] initWithDataObject:tapGestureRecognizer.dataObject];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        MagazineTabBarViewController *controller = [[MagazineTabBarViewController alloc] initWithDataObject:alertView.dataObject];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)reloadData
{
    for (int i = self.offset; i < [magazineArray count]; i++)
    {
        Magazine *magazine = [magazineArray objectAtIndex:i];
        
        UIView *contentView = [[UIView alloc] init];
        //        contentView.backgroundColor = [UIColor blueColor];
        if (i == 0)
        {
            UIImage *scrollViewBackgroundImage = [UIImage imageNamed:@"MagazineListBackground.png"];
            UIImageView *scrollViewBackgroundImageView = [[UIImageView alloc]
                                                          initWithImage:scrollViewBackgroundImage];
            scrollViewBackgroundImageView.frame = CGRectMake(0.0f,
                                                             0.0f,
                                                             scrollViewBackgroundImage.size.width,
                                                             scrollViewBackgroundImage.size.height);
            [contentView addSubview:scrollViewBackgroundImageView];
        }
        
        float y = kRowHeight * ceilf(i / 2);
        if (i % 2 == 0)
        {
            CGRect rect = CGRectMake(0.0f, y, self.view.frame.size.width, kMagazineContainerHeight);
            contentView.frame = rect;
            
            UIImage *shelfImage = [UIImage imageNamed:@"MagazineShelf.png"];
            UIImageView *shelfImageView = [[UIImageView alloc] initWithImage:shelfImage];
            shelfImageView.frame = CGRectMake(0.0f,
                                              150.0f,
                                              shelfImage.size.width,
                                              shelfImage.size.height);
            [contentView addSubview:shelfImageView];
                        
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(43.0f, 15.0f, kMagazineImageWidth, kMagazineImageHeight);
            imageView.backgroundColor = [UIColor lightGrayColor];
            
            UIImageView *reflectedImageView = [[UIImageView alloc] init];
            reflectedImageView.frame = CGRectMake(imageView.frame.origin.x,
                                                  imageView.frame.origin.y + kMagazineImageHeight + 1.0f,
                                                  kMagazineImageWidth,
                                                  kReflectedImageHeight);
            reflectedImageView.alpha = 0.3f;
            
            DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
            progressView.center = CGPointMake(imageView.frame.size.width / 2.0,
                                              imageView.frame.size.height / 2.0);
            [imageView addSubview:progressView];

            [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:magazine.coverImageUrlString] options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
                [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                if (finished)
                {
                    [progressView setProgress:1.0 animated:YES]; 
                    imageView.image = image;
                    UIImage *reflectedImage = [UIImage reflectedImage:imageView withHeight:kReflectedImageHeight];
                    reflectedImageView.image = reflectedImage;
                    [progressView removeFromSuperview];
                }
            }];
//            // Lactivity indicator view
//            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
//                                                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//            activityIndicatorView.frame = CGRectMake(0.0f,
//                                                     0.0f,
//                                                     kMagazineImageWidth,
//                                                     kMagazineImageHeight);
//            activityIndicatorView.center = CGPointMake(kMagazineImageWidth / 2,
//                                                       kMagazineImageHeight / 2);
//            [activityIndicatorView startAnimating];
//            [imageView addSubview:activityIndicatorView];
//            
//            dispatch_async(magazineImageQueue, ^{
//                NSLog(@"coverImageUrlString %@", magazine.coverImageUrlString);
//                if (magazine.coverImageUrlString != nil && [magazine.coverImageUrlString length] > 0)
//                {
//                    UIImage *image = [[UIImage alloc] initWithData:[magazine downloadCoverImage]];
//                    if (image != nil)
//                    {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            imageView.image = image;
//                            
//                            UIImage *reflectedImage = [UIImage reflectedImage:imageView withHeight:kReflectedImageHeight];
//                            reflectedImageView.image = reflectedImage;
//
//                            [activityIndicatorView stopAnimating];
//                            [magazine saveCoverImage];
//                        });
//                    }
//                    else
//                    {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [activityIndicatorView stopAnimating];
//                        });
//                    }
//                }
//                else
//                {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [activityIndicatorView stopAnimating];
//                    });
//                }
//            });
            
            
            if (magazine.hasDownloaded)
            {
                UIImage *downloadedImage = [UIImage imageNamed:@"MagazineDownloaded.png"];
                UIImageView *downloadedImageView = [[UIImageView alloc] initWithImage:downloadedImage];
                downloadedImageView.frame = CGRectMake(imageView.frame.size.width - downloadedImage.size.width,
                                                       imageView.frame.size.height - downloadedImage.size.height,
                                                       downloadedImage.size.width, downloadedImage.size.height);
                [imageView addSubview:downloadedImageView];
            }
            
            TapGestureRecognizer *tap = [[TapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(pressed:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            tap.dataObject = magazine.magazineId;
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES;
            
            [contentView addSubview:imageView];
            [contentView addSubview:reflectedImageView];
        }
        else
        {
            CGRect rect = CGRectMake(178.0f, y, self.view.frame.size.width - 178.0f, 170.0f);
            contentView.frame = rect;
            
            UIImage *image = [UIImage imageNamed:magazine.coverImageUrlString];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(0.0f, 15.0f, kMagazineImageWidth, kMagazineImageHeight);
            imageView.backgroundColor = [UIColor lightGrayColor];
            
            
//            UIImage *reflectedImage = [UIImage reflectedImage:imageView withHeight:7.0f];
            UIImageView *reflectedImageView = [[UIImageView alloc] init];
            reflectedImageView.frame = CGRectMake(imageView.frame.origin.x,
                                                  imageView.frame.origin.y + kMagazineImageHeight + 1.0f,
                                                  kMagazineImageWidth,
                                                  kReflectedImageHeight);
            reflectedImageView.alpha = 0.3f;
            
            DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
            progressView.center = CGPointMake(imageView.frame.size.width / 2.0,
                                              imageView.frame.size.height / 2.0);
            [imageView addSubview:progressView];
            
            [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:magazine.coverImageUrlString] options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
                [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                if (finished)
                {
                    [progressView setProgress:1.0 animated:YES];
                    imageView.image = image;
                    UIImage *reflectedImage = [UIImage reflectedImage:imageView withHeight:kReflectedImageHeight];
                    reflectedImageView.image = reflectedImage;
                    [progressView removeFromSuperview];
                }
            }];
//            // Lactivity indicator view
//            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
//                                                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//            activityIndicatorView.frame = CGRectMake(0.0f,
//                                                     0.0f,
//                                                     kMagazineImageWidth,
//                                                     kMagazineImageHeight);
//            activityIndicatorView.center = CGPointMake(kMagazineImageWidth / 2,
//                                                       kMagazineImageHeight / 2);
//            [activityIndicatorView startAnimating];
//            [imageView addSubview:activityIndicatorView];
//            
//            dispatch_async(magazineImageQueue, ^{
//                NSLog(@"coverImageUrlString %@", magazine.coverImageUrlString);
//                if (magazine.coverImageUrlString != nil && [magazine.coverImageUrlString length] > 0)
//                {
//                    UIImage *image = [[UIImage alloc] initWithData:[magazine downloadCoverImage]];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        imageView.image = image;
//                        
//                        UIImage *reflectedImage = [UIImage reflectedImage:imageView withHeight:kReflectedImageHeight];
//                        reflectedImageView.image = reflectedImage;
//                        
//                        [activityIndicatorView stopAnimating];
//                    });
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [magazine saveCoverImage];
//                    });
//                }
//                else
//                {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [activityIndicatorView stopAnimating];
//                    });
//                }
//            });
            
            
            if (magazine.hasDownloaded)
            {
                UIImage *downloadedImage = [UIImage imageNamed:@"MagazineDownloaded.png"];
                UIImageView *downloadedImageView = [[UIImageView alloc]
                                                    initWithImage:downloadedImage];
                downloadedImageView.frame = CGRectMake(imageView.frame.size.width - downloadedImage.size.width,
                                                       imageView.frame.size.height - downloadedImage.size.height,
                                                       downloadedImage.size.width,
                                                       downloadedImage.size.height);
                [imageView addSubview:downloadedImageView];
            }
            
            TapGestureRecognizer *tap = [[TapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(pressed:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            tap.dataObject = magazine.magazineId;
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES;
            [contentView addSubview:imageView];
            [contentView addSubview:reflectedImageView];
        }
        
        
        
        [self.scrollView addSubview:contentView];
    }
    
    self.scrollView.pagingEnabled = NO;
    float height = kMagazineContainerHeight * ceil([magazineArray count] / 2.0);
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
}

#pragma mark - Scroll view delegate
- (void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    if (!self.isLoadingData && !self.isEnded)
    {

        NSInteger rowCount = ceil([self.magazineArray count] / 2);
        float height = kMagazineContainerHeight * rowCount;
        if (self.scrollView.frame.size.height + self.scrollView.contentOffset.y >= height - 100.0)
        {
            self.isLoadingData = YES;
            CGSize size = self.scrollView.contentSize;
            size.height += kLoadingAIVHeight;
            self.scrollView.contentSize = size;
            
            [self.loadingAIV startAnimating];
//            self.loadingAIV.hidden = NO;

            NSInteger count = [self.magazineArray count];
            self.offset += kPageSize;

            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, queue, ^{
                Result *result = [Magazine getList:NO
                                             isNew:NO
                                            offset:self.offset
                                             limit:self.limit];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.loadingAIV stopAnimating];
                    
                    if (result.data != nil);
                    {
                        [self.magazineArray addObjectsFromArray:result.data];
                    }
                    
                    if (count == [self.magazineArray count])
                    {
                        self.isEnded = YES;
                    }
                    else
                    {
                        [self reloadData];
                    }

                    CGSize size = self.scrollView.contentSize;
                    size.height = kMagazineContainerHeight * ceil([self.magazineArray count] / 2.0);
                    self.scrollView.contentSize = size;
                });
            });
        }
    }
}

@end
