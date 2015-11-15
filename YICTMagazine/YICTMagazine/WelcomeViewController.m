//
//  WelcomeViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-9-6.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kContentTag 101

#import "WelcomeViewController.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "DACircularProgressView.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface WelcomeViewController ()

@property (nonatomic, readwrite) BOOL isSwiped;

@end

@implementation WelcomeViewController

@synthesize scrollView;
@synthesize sceneView;
//@synthesize activityIndicatorView;
@synthesize coverView;
@synthesize upImageView;
@synthesize isDragDown;
//@synthesize tipsLabel;
@synthesize logoImageView;
@synthesize logoBackgroundImageView;

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
	// Do any additional setup after loading the view.
    // Get data
    Result *result = [LaunchImage getInfo];
    if (result.isSuccess)
    {
        _launchImage = result.data;
    }

    
    
    // Scroll view
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0.0f,
                                       0.0f,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                             self.view.frame.size.height * 2);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    

    
    // Content
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(0.0f,
                                   0.0f,
                                   self.view.frame.size.width,
                                   self.view.frame.size.height);
    contentView.backgroundColor = [UIColor colorWithRed:(0.0f / 255.0f)
                                                  green:(65.0f / 255.0f)
                                                   blue:(134.0f / 255.0f)
                                                  alpha:1.0f];
    contentView.tag = kContentTag;
   

    
    // Scenes
    self.sceneView = [[UIImageView alloc] init];
    self.sceneView.frame = CGRectMake(0.0f,
                                      0.0f,
                                      self.view.frame.size.width,
                                      self.view.frame.size.height);
    self.sceneView.backgroundColor = [UIColor clearColor];
    self.sceneView.alpha = 0.0;
    self.sceneView.userInteractionEnabled = YES;
    
    UISwipeGestureRecognizer *swpieLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rollLaunchImage:)];
    swpieLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.sceneView addGestureRecognizer:swpieLeft];
    
    UISwipeGestureRecognizer *swpieRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rollLaunchImage:)];
    swpieRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.sceneView addGestureRecognizer:swpieRight];
    
    [contentView addSubview:self.sceneView];
    
    
      // Logo background
    self.logoBackgroundImageView = [[UIImageView alloc] init];
    self.logoBackgroundImageView.image = [UIImage imageNamed:@"LogoBackground.png"];
    self.logoBackgroundImageView.frame = CGRectMake(0.0f,
                                                    self.view.frame.size.height - self.logoBackgroundImageView.image.size.height,
                                                    self.logoBackgroundImageView.image.size.width,
                                                    self.logoBackgroundImageView.image.size.height);
    self.logoBackgroundImageView.alpha = 0.0;
    

    [contentView addSubview:logoBackgroundImageView];
    
    
    // Logo
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.image = [UIImage imageNamed:@"Logo.png"];
    self.logoImageView.frame = CGRectMake((self.view.frame.size.width - self.logoImageView.image.size.width) / 2.0,
                                          (self.view.frame.size.height - self.logoImageView.image.size.height) / 2.0,
                                          self.logoImageView.image.size.width,
                                          self.logoImageView.image.size.height);
    [contentView addSubview:self.logoImageView];
    
    

    // Up button
    self.upImageView = [[UIImageView alloc] init];
    self.upImageView.image = [UIImage imageNamed:@"Up.png"];
    self.upImageView.frame = CGRectMake((self.view.frame.size.width - self.upImageView.image.size.width) / 2,
                                        self.view.frame.size.height - 30.0f,
                                        self.upImageView.image.size.width,
                                        self.upImageView.image.size.height);
    self.upImageView.alpha = 0.0f;
    [contentView addSubview:upImageView];
    
    


    
    [self.scrollView addSubview:contentView];
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _launchImage = nil;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:1.0 animations:^{
        self.logoImageView.frame = CGRectMake(self.logoImageView.frame.origin.x,
                                              self.view.frame.size.height - self.logoImageView.image.size.height - 55.0,
                                              self.logoImageView.frame.size.width,
                                              self.logoImageView.frame.size.height);
    } completion:^(BOOL isFinished) {
        if (isFinished)
        {
            [UIView animateWithDuration:1.0 animations:^{
                self.logoBackgroundImageView.alpha = 1.0;
            } completion:nil];
            
            if (_launchImage != nil && _launchImage.imageUrlString != nil)
            {
                UIView *contentView = [self.scrollView viewWithTag:kContentTag];
                DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
                progressView.center = contentView.center;
                if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_launchImage.imageUrlString] != nil)
                {
                    progressView.hidden = YES;
                }
                [contentView addSubview:progressView];
                
                [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:_launchImage.imageUrlString] options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
                    [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                    if (finished)
                    {
                        [progressView setProgress:1.0 animated:YES];                        
                        self.sceneView.image = image;
                        float imageWidth = self.sceneView.image.size.width * self.view.frame.size.height / self.sceneView.image.size.height;
                        self.sceneView.frame = CGRectMake(self.sceneView.frame.origin.x,
                                                          self.sceneView.frame.origin.y,
                                                          imageWidth,
                                                          self.sceneView.frame.size.height);
                        [progressView removeFromSuperview];
                        [self showImage];
                    }
                }];
            }
            else
            {
                self.sceneView.image = [UIImage imageNamed:@"WelcomeView.png"];
                [self showImage];
            }
        }
    }];
}

- (void)showImage
{
    float imageWidth = self.sceneView.image.size.width * self.view.frame.size.height / self.sceneView.image.size.height;
    if (_launchImage != nil && _launchImage.isLeftToRight)
    {
        self.sceneView.frame = CGRectMake(self.sceneView.frame.origin.x,
                                          self.sceneView.frame.origin.y,
                                          imageWidth,
                                          self.sceneView.frame.size.height);
    }
    else
    {
        self.sceneView.frame = CGRectMake(self.view.frame.size.width - imageWidth,
                                          self.sceneView.frame.origin.y,
                                          imageWidth,
                                          self.sceneView.frame.size.height);
    }
    
    [UIView animateWithDuration:1.5 animations:^{
        self.coverView.alpha = 0.0;
//        self.activityIndicatorView.alpha = 1.0;
        self.sceneView.alpha = 1.0;
//        self.upImageView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (finished)
        {
            
//            float seconds = floor(self.sceneView.image.size.width / self.view.frame.size.width) * 3.0;
//            [UIView animateWithDuration:seconds animations:^{
//                if (_launchImage != nil && _launchImage.isLeftToRight)
//                {
//                    self.sceneView.frame = CGRectMake((imageWidth - self.view.frame.size.width) * -1,
//                                                      0.0f,
//                                                      self.sceneView.frame.size.width,
//                                                      self.sceneView.frame.size.height);
//                }
//                else
//                {
//                    self.sceneView.frame = CGRectMake(0.0f,
//                                                      0.0f,
//                                                      self.sceneView.frame.size.width,
//                                                      self.sceneView.frame.size.height);
//
//                }
//            } completion:nil];
   
            
        }
    }];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.upImageView.alpha = 1.0;
    } completion:^(BOOL isFinished) {
        if (isFinished)
        {
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(rollUpImageView:)
                                           userInfo:nil
                                            repeats:YES];
        }
    }];
}

- (void)rollUpImageView:(NSTimer*)timer
{
    self.upImageView.frame = CGRectMake(self.upImageView.frame.origin.x,
                                        self.view.frame.size.height - 30.0f,
                                        self.upImageView.image.size.width,
                                        self.upImageView.image.size.height);
    [UIView animateWithDuration:1.0f animations:^{
        self.upImageView.frame = CGRectMake(self.upImageView.frame.origin.x,
                                            self.view.frame.size.height - 45.0f,
                                            self.upImageView.image.size.width,
                                            self.upImageView.image.size.height);
    } completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isDragDown = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    if (self.isDragDown)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollView.contentOffset = CGPointZero;
        } completion:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender.contentOffset.y < 0)
    {
        sender.contentOffset = CGPointZero;
        self.isDragDown = YES;
    }
    else if (sender.contentOffset.y == self.view.frame.size.height)
    {
        self.view.hidden = YES;
        self.sceneView.image = nil;
    }
}

- (void)rollLaunchImage:(UISwipeGestureRecognizer *)swipe
{
    NSLog(@"rollLaunchImage");
    
    if (self.sceneView.image != nil && self.isSwiped == NO)
    {
        self.isSwiped = YES;
        
        
        float imageWidth = self.sceneView.image.size.width * self.view.frame.size.height / self.sceneView.image.size.height;
        float seconds = floor(self.sceneView.image.size.width / self.view.frame.size.width) * 3.0;
        
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
        {
            self.sceneView.frame = CGRectMake(self.sceneView.frame.origin.x,
                                              self.sceneView.frame.origin.y,
                                              imageWidth,
                                              self.sceneView.frame.size.height);
        }
        else
        {
            self.sceneView.frame = CGRectMake(self.view.frame.size.width - imageWidth,
                                              self.sceneView.frame.origin.y,
                                              imageWidth,
                                              self.sceneView.frame.size.height);
        }
        
        
        [UIView animateWithDuration:seconds animations:^{
            if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
            {
                self.sceneView.frame = CGRectMake((imageWidth - self.view.frame.size.width) * -1,
                                                  0.0f,
                                                  self.sceneView.frame.size.width,
                                                  self.sceneView.frame.size.height);
            }
            else
            {
                self.sceneView.frame = CGRectMake(0.0f,
                                                  0.0f,
                                                  self.sceneView.frame.size.width,
                                                  self.sceneView.frame.size.height);
                
            }
        } completion:^(BOOL isFinished) {
            if (isFinished)
            {
                self.isSwiped = NO;
            }
        }];
        
    }
}

@end
