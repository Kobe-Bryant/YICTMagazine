//
//  MagazineZoomImageViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-23.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kStatusBarHeight 20.0
#define kTabBarHeight 49.0
#define kImageX 10.0
//#define kImageWidth 286.0f
//#define kImageHeight 405.0f
//#define kImageWidth 291.0
#define kImageHeight 411.0
#define kZoomViewTag 100
#define kZoomStep 3

#import "MagazineImageViewController.h"
#import "AppDelegate.h"
#import "MagazineImage.h"
#import "DACircularProgressView.h"

#import "SDWebImage/UIImageView+WebCache.h"

@interface MagazineImageViewController (UtilityMethods)

@end

@implementation MagazineImageViewController

@synthesize magazineImageViewDelegate;
@synthesize scrollView;
@synthesize pagerView;
@synthesize dataObject;
@synthesize index;
@synthesize viewCount;
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFrame:(CGRect)rect
{
    self = [super init];
	if (self)
    {
        self.view.frame = rect;
	}
	return self;
}

- (id)initWithFrame:(CGRect)rect dataObject:(id)_dataObject index:(NSInteger)_index viewCount:(NSInteger)_viewCount
{

    self = [super init];
	if (self)
    {
        self.frameRect = rect;
        self.dataObject = _dataObject;
        self.index = _index;
        self.viewCount = _viewCount;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isZoomIn = YES;
    _zoomTimes = 0;

    // Background
    UIImage *backgroudImage = [UIImage imageNamed:@"Background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroudImage];



    
    UIView *containerView = [[UIView alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        containerView.frame = CGRectMake(self.view.bounds.origin.x,
                                         kStatusBarHeight,
                                         self.view.bounds.size.width,
                                         self.view.bounds.size.height - kStatusBarHeight - kTabBarHeight);
    }
    else
    {
        containerView.frame = CGRectMake(self.view.bounds.origin.x,
                                         0.0,
                                         self.view.bounds.size.width,
                                         self.view.bounds.size.height - kTabBarHeight);
    }
    [self.view addSubview:containerView];

    
    // Init scroll view
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0.0,
                                       0.0,
                                       containerView.frame.size.width,
                                       containerView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.scrollsToTop = YES;
    self.scrollView.delegate = self;
    self.scrollView.bouncesZoom = YES;
    [containerView addSubview:self.scrollView];

    
    // add touch-sensitive image view to the scroll view
    self.imageView = [[TapDetectingImageView alloc] init];
    self.imageView.delegate = self;
    self.imageView.tag = kZoomViewTag;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.frame = self.scrollView.frame;
    [self.scrollView addSubview:self.imageView];


    MagazineImage *magazineImage = dataObject;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        if (magazineImage.origImageUrlString != nil
            && [magazineImage.origImageUrlString length] > 0)
        {
            DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
            progressView.center = imageView.center;
            if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:magazineImage.origImageUrlString] != nil)
            {
                progressView.hidden = YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageView addSubview:progressView];
            });


            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            activityIndicatorView.frame = self.imageView.frame;
            activityIndicatorView.center = CGPointMake(self.imageView.frame.size.width / 2.0,
                                                       self.imageView.frame.size.height / 2.0);
            if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:magazineImage.origImageUrlString] != nil)
            {
                [activityIndicatorView startAnimating];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageView addSubview:activityIndicatorView];
            });

            [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:magazineImage.origImageUrlString] options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
                });
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                if (finished)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [progressView setProgress:1.0 animated:YES];
                        [progressView removeFromSuperview];
                        [activityIndicatorView startAnimating];
                    });

                    if (image != nil)
                    {

                        CGFloat imageWidth = self.view.bounds.size.width;
                        CGFloat imageHeight = image.size.height * self.view.bounds.size.width / image.size.width;
                        if (imageHeight > containerView.frame.size.height)
                        {
                            imageWidth = image.size.width * containerView.frame.size.height / image.size.height;
                            imageHeight = containerView.frame.size.height;
                        }
                        
                        CGSize imageSize = CGSizeMake(imageWidth, imageHeight);
                        UIGraphicsBeginImageContext(imageSize);
                        [image drawInRect:CGRectMake(0.0, 0.0, imageSize.width, imageSize.height)];
                        CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(),
                                                         kCGInterpolationHigh);
                        __block UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();

                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.imageView.image = thumbImage;
                            self.imageView.frame = CGRectMake(0.0,
                                                              0.0,
                                                              image.size.width,
                                                              image.size.height);
                            
                            // calculate minimum scale to perfectly fit image width, and begin at that scale
                            if ((containerView.frame.size.height - thumbImage.size.height) / 2.0 > 20.0)
                            {
                                self.scrollView.frame = CGRectMake((containerView.frame.size.width - thumbImage.size.width) / 2.0,
                                                                   (containerView.frame.size.height - thumbImage.size.height) / 4.0,
                                                                   thumbImage.size.width,
                                                                   thumbImage.size.height);
                            }
                            else
                            {
                                self.scrollView.frame = CGRectMake((containerView.frame.size.width - thumbImage.size.width) / 2.0,
                                                                   (containerView.frame.size.height - thumbImage.size.height) / 2.0,
                                                                   thumbImage.size.width,
                                                                   thumbImage.size.height);
                            }
                            
                            self.scrollView.minimumZoomScale = thumbImage.size.width / image.size.width;
                            [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
                            
                            self.pagerView.hidden = NO;
                            [activityIndicatorView removeFromSuperview];
                            thumbImage = nil;
                        });
                    }
                }
            }];
        }
    });

    
    // Page number
    self.pagerView = [[UIImageView alloc] init];
    UIImage *pagerBackgroundImage = [UIImage imageNamed:@"MagazineImagePagerBackground.png"];
    self.pagerView.image = pagerBackgroundImage;
    self.pagerView.frame = CGRectMake((self.view.bounds.size.width - pagerBackgroundImage.size.width) / 2.0,
                                      self.view.bounds.size.height - kTabBarHeight - pagerBackgroundImage.size.height - 7.0,
                                      pagerBackgroundImage.size.width,
                                      pagerBackgroundImage.size.height);
    
    self.pagerTextLabel = [[UILabel alloc] init];
    self.pagerTextLabel.backgroundColor = [UIColor clearColor];
    self.pagerTextLabel.font = [UIFont systemFontOfSize:10.0];
    self.pagerTextLabel.textColor = [UIColor whiteColor];
    self.pagerTextLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"Page %i / %i", nil), (self.index + 1), self.viewCount];
    [self.pagerTextLabel sizeToFit];
    self.pagerTextLabel.frame = CGRectMake((self.pagerView.frame.size.width - self.pagerTextLabel.frame.size.width) / 2.0,
                                           (self.pagerView.frame.size.height - self.pagerTextLabel.frame.size.height) / 2.0,
                                           self.pagerTextLabel.frame.size.width,
                                           self.pagerTextLabel.frame.size.height);
    [self.pagerView addSubview:self.pagerTextLabel];
    [self.view addSubview:self.pagerView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    UIViewController *galleryVC = self.parentViewController.parentViewController;
    if (galleryVC == nil)
    {
        self.imageView.image = nil;
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect rect;
    UIView *containerView = [self.view.subviews objectAtIndex:0];

    CGFloat imageWidth = self.view.bounds.size.width;
    CGFloat imageHeight = self.imageView.image.size.height * self.view.bounds.size.width / self.imageView.image.size.width;
    if (imageHeight > containerView.frame.size.height)
    {
        imageWidth = self.imageView.image.size.width * containerView.frame.size.height / self.imageView.image.size.height;
        imageHeight = containerView.frame.size.height;
    }
    
    CGSize minImageSize = CGSizeMake(imageWidth, imageHeight);

    if (self.scrollView.contentSize.width >= containerView.frame.size.width)
    {
        rect.origin.x = 0.0;
    }
    else
    {
        rect.origin.x = (containerView.frame.size.width - minImageSize.width) / 2.0;
    }
    
    if (self.scrollView.contentSize.height >= containerView.frame.size.height)
    {
        rect.origin.y = 0.0;
    }
    else if ((containerView.frame.size.height - minImageSize.width) / 2.0 > 20.0)
    {
        rect.origin.y = (containerView.frame.size.height - minImageSize.height) / 4.0;
    }
    else
    {
        rect.origin.y = (containerView.frame.size.height - minImageSize.height) / 2.0;
    }
    
    if (self.scrollView.contentSize.width >= containerView.frame.size.width)
    {
        rect.size.width = containerView.frame.size.width;
    }
    else
    {
        rect.size.width = minImageSize.width;
    }
    
    if (self.scrollView.contentSize.height >= containerView.frame.size.height)
    {
        rect.size.height = containerView.frame.size.height;
    }
    else
    {
        rect.size.height = minImageSize.height;
    }
    
    self.scrollView.frame = rect;
    
    self.pagerView.hidden = YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sender
{
//    NSLog(@"viewForZoomingInScrollView");
//    return [(UIScrollView *)self.view viewWithTag:kZoomViewTag];
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{

    if (self.scrollView.minimumZoomScale == scale)
    {
        self.pagerView.hidden = NO;
    }
    
    MagazineImage *magazineImage = self.dataObject;
    if (magazineImage.origImageUrlString != nil
        && [magazineImage.origImageUrlString length] > 0)
    {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.frame = CGRectMake(0.0, 0.0, 80.0, 80.0);
        activityIndicatorView.center = CGPointMake(self.view.bounds.size.width / 2.0,
                                                   self.view.bounds.size.height / 2.0);
        //activityIndicatorView.layer.cornerRadius = 10.0;
       // activityIndicatorView.layer.masksToBounds = YES;
        activityIndicatorView.backgroundColor = [UIColor blackColor];
        activityIndicatorView.alpha = 0.7;
        [activityIndicatorView startAnimating];
        [self.view addSubview:activityIndicatorView];
        
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:magazineImage.origImageUrlString] options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (finished)
            {
                UIGraphicsBeginImageContext(CGSizeMake(self.scrollView.contentSize.width,
                                                       self.scrollView.contentSize.height));
                [image drawInRect:CGRectMake(0.0,
                                             0.0,
                                             self.scrollView.contentSize.width,
                                             self.scrollView.contentSize.height)];
                CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(),
                                                 kCGInterpolationHigh);
                __block UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = thumbImage;
                    [activityIndicatorView stopAnimating];
                    [activityIndicatorView removeFromSuperview];
                    
                    thumbImage = nil;
                });
            }
        }];
    }
}

#pragma mark -
#pragma mark TapDetectingImageViewDelegate methods
- (void)tapDetectingImageView:(TapDetectingImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint
{
    // single tap does nothing for now
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint
{
    // double tap zooms in / out
    _isTapAction = YES;
    
    if ([scrollView zoomScale] < 1.0)
    {
        
        float newScale = [scrollView zoomScale] * kZoomStep;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
    else
    {
        [self.scrollView setZoomScale:_minimumScale animated:YES];
    }
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint
{
    // two-finger does nothing for now
}


#pragma mark -
#pragma mark Utility methods
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
    zoomRect.size.height = self.scrollView.frame.size.height / scale;
    zoomRect.size.width  = self.scrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);

    return zoomRect;
}

@end
