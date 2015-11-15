//
//  NewsGalleryViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-21.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "NewsGalleryViewController.h"
#import "NewsImage.h"
#import "AppDelegate.h"

@interface NewsGalleryViewController ()

@end

@implementation NewsGalleryViewController

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
    self.title = NSLocalizedString(@"Photo", nil);


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
    self.navigationController.view.backgroundColor = [UIColor blackColor];

    
    
    // Gallery
    NSArray *newsImageArray = self.dataObject;
    _newsGalleryImageSVC = [[NewsGalleryImageScrollViewController alloc] initWithFrame:self.view.frame
                                                                            dataObject:newsImageArray
                                                                         selectedIndex:selectedIndex];
    [self.view addSubview:_newsGalleryImageSVC.view];
    
    
    
    // Default device orientation
    _deviceOrientation = UIDeviceOrientationPortrait;
}

- (void)viewDidAppear:(BOOL)animated
{
    // Device rotate
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    [self reloadView:orientation];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadView:(UIDeviceOrientation)orientation
{
    [UIView animateWithDuration:0.25 animations:^{
        if (orientation == UIDeviceOrientationLandscapeLeft)
        {
            [self.view setTransform:CGAffineTransformMakeRotation(M_PI / 2.0)];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                self.view.frame = CGRectMake(0.0, 64.0, self.view.frame.size.height, self.view.frame.size.width);
            }
            else
            {
                self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.height, self.view.frame.size.width);
            }
            
            [_newsGalleryImageSVC reloadView];
            
            _deviceOrientation = orientation;
        }
        else if (orientation == UIDeviceOrientationLandscapeRight)
        {
            [self.view setTransform:CGAffineTransformMakeRotation(M_PI / -2.0)];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                self.view.frame = CGRectMake(0.0, 64.0, self.view.frame.size.height, self.view.frame.size.width);
            }
            else
            {
                self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.height, self.view.frame.size.width);
            }
            
            [_newsGalleryImageSVC reloadView];
            
            _deviceOrientation = orientation;
        }
        else if (orientation == UIDeviceOrientationPortraitUpsideDown)
        {
            [self.view setTransform:CGAffineTransformMakeRotation(M_PI)];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                self.view.frame = CGRectMake(0.0, 64.0, self.view.frame.size.height, self.view.frame.size.width);
            }
            else
            {
                self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.height, self.view.frame.size.width);
            }
            
            [_newsGalleryImageSVC reloadView];
            
            _deviceOrientation = orientation;
        }
        else if (orientation == UIDeviceOrientationPortrait)
        {            
            [self.view setTransform:CGAffineTransformMakeRotation(0.0)];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                self.view.frame = CGRectMake(0.0, 64.0, self.view.frame.size.height, self.view.frame.size.width);
            }
            else
            {
                self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.height, self.view.frame.size.width);
            }
            
            [_newsGalleryImageSVC reloadView];
            
            _deviceOrientation = orientation;
        }
    } completion:^(BOOL finished) {
        if (finished)
        {
        }
    }];
}

- (void)didRotate:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation != UIDeviceOrientationUnknown
        && orientation != UIDeviceOrientationFaceUp
        && orientation != UIDeviceOrientationFaceDown
        && orientation != _deviceOrientation
        && ((orientation == UIDeviceOrientationPortrait && _deviceOrientation != UIDeviceOrientationPortraitUpsideDown)
            || (orientation == UIDeviceOrientationPortraitUpsideDown && _deviceOrientation != UIDeviceOrientationPortrait)
            || (orientation == UIDeviceOrientationLandscapeLeft && _deviceOrientation != UIDeviceOrientationLandscapeRight)
            || (orientation == UIDeviceOrientationLandscapeRight && _deviceOrientation != UIDeviceOrientationLandscapeLeft))
        )
    {
        [self willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:0.25];
    }
}

@end
