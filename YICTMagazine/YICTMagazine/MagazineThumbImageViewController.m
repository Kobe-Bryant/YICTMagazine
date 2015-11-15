//
//  MagazineThumbImageViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-25.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kContentViewWidth 270.0f
#define kContentTopHeight 18.0f
#define kImageViewHeight 122.f
#define kImageWidth 60.0f
#define kImageHeight 85.0f
#define kImageHorizontalInterval 23.0f

#import "MagazineThumbImageViewController.h"
#import "AppDelegate.h"
#import "MagazineImage.h"
#import "MagazineTabBarViewController.h"
#import "DACircularProgressView.h"

#import "SDWebImage/UIImageView+WebCache.h"

@interface MagazineThumbImageViewController ()

@end

@implementation MagazineThumbImageViewController

@synthesize magazineTabBarSwitchDelegate;
@synthesize dataObject;
@synthesize scrollView;

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
    // Background
    UIImage *backgroudImage = [UIImage imageNamed:@"Background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroudImage];
    
    
    // Fix IOS7 compatibility
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.view.frame = CGRectMake(0.0,
                                     20.0,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height - 20.0);
    }
    
    
    // Data
    NSMutableArray *magazineImageArray = self.dataObject;
    
    
    
    // Image
    scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.frame;
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    

    
    
    CGFloat firstCloumnEmptyWidth = (self.view.frame.size.width - (kImageWidth * 4) - kImageHorizontalInterval) / 2;
    NSUInteger last = [magazineImageArray count] % 2  == 0 ? [magazineImageArray count] - 1: [magazineImageArray count];
    for (int i = 0; i <= [magazineImageArray count]; i++)
    {
        UIView *contentView = [[UIView alloc] init];
        CGFloat x = firstCloumnEmptyWidth + kImageWidth * (i % 4);
        if (i % 4 > 1)
        {
            x += kImageHorizontalInterval;
        }
        float y = kImageViewHeight * ceilf(i / 4) + kContentTopHeight;
        contentView.frame = CGRectMake(x, y, kImageWidth, kImageHeight);
        if (i > 0)
        {
            NSInteger index = i - 1;
            MagazineImage *magazineImage = [magazineImageArray objectAtIndex:index];
            UIImageView *imageView  = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(0.0f,
                                         0.0f,
                                         contentView.frame.size.width,
                                         contentView.frame.size.height);
            imageView.backgroundColor = [UIColor lightGrayColor];
            imageView.tag = index;
            
            DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
            progressView.center = CGPointMake(imageView.frame.size.width / 2.0,
                                              imageView.frame.size.height / 2.0);
            [imageView addSubview:progressView];
            
            [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:magazineImage.thumbImageUrlString] options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
                [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                if (finished)
                {
                    [progressView setProgress:1.0 animated:YES];                    
                    imageView.image = image;
                    [progressView removeFromSuperview];
                }
            }];
            
            
//            // Lactivity indicator view
//            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
//                                                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//            activityIndicatorView.frame = CGRectMake(0.0f,
//                                                     0.0f,
//                                                     contentView.frame.size.width,
//                                                     contentView.frame.size.height);
//            activityIndicatorView.center = CGPointMake(contentView.frame.size.width / 2,
//                                                       contentView.frame.size.height / 2);
//            [activityIndicatorView startAnimating];
//            [imageView addSubview:activityIndicatorView];
//
//            dispatch_async(newsImageQueue, ^{
//                if (magazineImage.thumbImageUrlString != nil && [magazineImage.thumbImageUrlString length] > 0)
//                {
//                    UIImage *image = [[UIImage alloc] initWithData:[magazineImage downloadThumbImage]];
//                    if (image != nil)
//                    {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            imageView.image = image;
//                            [activityIndicatorView stopAnimating];
//                            [magazineImage saveThumbImage];
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
            
            [contentView addSubview:imageView];
        
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(pressed:)];
            [tap setNumberOfTapsRequired:1];
            [tap setNumberOfTouchesRequired:1];
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES;
            
        
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.textColor = [UIColor whiteColor];
            textLabel.font = [UIFont systemFontOfSize:12.0f];
            textLabel.text = [[NSString alloc] initWithFormat:@"%i", index + 1];
            [textLabel sizeToFit];
            textLabel.frame = CGRectMake((contentView.frame.size.width - textLabel.frame.size.width) / 2,
                                         kImageHeight + 8.0f,
                                         textLabel.frame.size.width,
                                         textLabel.frame.size.height);
            [contentView addSubview:textLabel];
        }
        
        if (i > 1 && i <= last)
        {
            UIImageView *shadowImageView = [[UIImageView alloc] init];
            if (i % 2 == 0)
            {
                shadowImageView.image = [UIImage imageNamed:@"MagazineThumbLeftShadow.png"];
                shadowImageView.frame = CGRectMake(kImageWidth - shadowImageView.image.size.width,
                                                   0.0f,
                                                   shadowImageView.image.size.width,
                                                   shadowImageView.image.size.height);
            }
            else
            {
                shadowImageView.image = [UIImage imageNamed:@"MagazineThumbRightShadow.png"];
                shadowImageView.frame = CGRectMake(0.0f,
                                                   0.0f,
                                                   shadowImageView.image.size.width,
                                                   shadowImageView.image.size.height);
            }
            [contentView addSubview:shadowImageView];            
        }
        
        [scrollView addSubview:contentView];
    }
    
    scrollView.pagingEnabled = NO;
    float height = kContentTopHeight + kImageViewHeight * ceil(([magazineImageArray count] + 1.0) / 4.0);
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
    [self.view addSubview:scrollView];    
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.scrollView.frame = CGRectMake(0.0,
                                     20.0,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height - 20.0);
    }
    else
    {
        self.scrollView.frame = CGRectMake(0.0,
                                           0.0,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pressed:(UITapGestureRecognizer *)sender
{
    [self.magazineTabBarSwitchDelegate setMagazineGallerySelectedIndex:sender.view.tag];
    [self.magazineTabBarSwitchDelegate tabBarSwitchButtonPress:self];
}

@end
