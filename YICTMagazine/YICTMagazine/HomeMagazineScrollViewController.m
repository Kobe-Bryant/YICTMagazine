//
//  HomeMagazineScrollViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-9-4.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kColumnPerRow 3
#define kMagazineImageWidth 100.0f
#define kMagazineImageHeight 142.0f

#import "HomeMagazineScrollViewController.h"
#import "TapGestureRecognizer.h"
#import "Magazine.h"
#import "AppDelegate.h"
#import "DACircularProgressView.h"

#import "SDWebImage/UIImageView+WebCache.h"

@interface HomeMagazineScrollViewController ()

@end

@implementation HomeMagazineScrollViewController

@synthesize delegate;
//@synthesize dataObject;

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
    self.view.backgroundColor = [UIColor yellowColor];

    
    NSArray *magazineArray = _dataObject;
    NSUInteger pageCount = floor([magazineArray count] / 3);
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0.0f,
                                   0.0f,
                                   self.view.frame.size.width,
                                   self.view.frame.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_rect.size.width * pageCount,
                                         _rect.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor colorWithRed:(236.0f / 255.0f)
                                                  green:(236.0f / 255.0f)
                                                   blue:(236.0f / 255.0f)
                                                  alpha:1.0f];
    for (int i = 0; i < [magazineArray count]; i++)
    {
        // Image
        Magazine *magazine = [magazineArray objectAtIndex:i];
        UIImageView *magazineImageView = [[UIImageView alloc] init];
        CGFloat separatorWidth = (_rect.size.width - kMagazineImageWidth * 3.0f) / 4.0f;
        CGFloat x = separatorWidth * (i + 1 + ceil(i / 3)) + (kMagazineImageWidth * i);
        CGFloat y = (_rect.size.height - kMagazineImageHeight) / 2;
        magazineImageView.frame = CGRectMake(x,
                                             y,
                                             kMagazineImageWidth,
                                             kMagazineImageHeight);
        magazineImageView.backgroundColor = [UIColor lightGrayColor];
        magazineImageView.userInteractionEnabled = YES;
        
        DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
        progressView.center = CGPointMake(magazineImageView.frame.size.width / 2.0,
                                          magazineImageView.frame.size.height / 2.0);
        [magazineImageView addSubview:progressView];

        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:magazine.coverImageUrlString] options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
            [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (finished)
            {
                [progressView setProgress:1.0 animated:YES]; 
                magazineImageView.image = image;
                [progressView removeFromSuperview];
            }
        }];
        
        if (magazine.hasDownloaded)
        {
            UIImage *downloadedImage = [UIImage imageNamed:@"MagazineDownloaded.png"];
            UIImageView *downloadedImageView = [[UIImageView alloc] initWithImage:downloadedImage];
            downloadedImageView.frame = CGRectMake(magazineImageView.frame.size.width - downloadedImage.size.width,
                                                   magazineImageView.frame.size.height - downloadedImage.size.height,
                                                   downloadedImage.size.width,
                                                   downloadedImage.size.height);
            [magazineImageView addSubview:downloadedImageView];
        }
        
        
        TapGestureRecognizer *imageTap = [[TapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(pressed:)];
        imageTap.numberOfTapsRequired = 1;
        imageTap.numberOfTouchesRequired = 1;
        imageTap.dataObject = magazine.magazineId;
		[magazineImageView addGestureRecognizer:imageTap];

        [_scrollView addSubview:magazineImageView];
    }
    
    [self.view addSubview:_scrollView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pressed:(TapGestureRecognizer*)sender
{
//    NSLog(@"%@", sender.dataObject);
    [self.delegate magazineViewPressed:sender.dataObject];
}

@end
