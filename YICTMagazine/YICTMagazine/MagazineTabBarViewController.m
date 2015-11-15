//
//  MagazineTabBarViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-23.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kTabBarButtonHeight 44.0f
#define kTabBarButtonWidth 80.0f

#import <QuartzCore/QuartzCore.h>
#import "MagazineTabBarViewController.h"
#import "MagazineThumbImageViewController.h"
#import "MagazineImageTitleViewController.h"

@interface MagazineTabBarViewController ()

@property (nonatomic, strong) NSMutableArray *subControllers;
@property (nonatomic, strong) NSArray *tabBarButtonOptions;
@property (nonatomic, readwrite) NSInteger gallerySelectedIndex;

@end

@implementation MagazineTabBarViewController

@synthesize magazineGalleryVC;
@synthesize dataObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDataObject:(id)_dataObject
{
    self.dataObject = _dataObject;
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
    // Tab bar buttons
    self.tabBarButtonOptions = [NSArray arrayWithObjects:
                                [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"TabBarBackSelected.png", @"selectedImage",
                                 @"TabBarBackUnselected.png", @"unselectedImage", nil],
                                [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"TabBarGallerySelected.png", @"selectedImage",
                                 @"TabBarGalleryUnselected.png", @"unselectedImage", nil],
                                [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"TarBarThumbSelected.png", @"selectedImage",
                                 @"TarBarThumbUnselected.png", @"unselectedImage", nil],
                                [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"TarBarImageTitleSelected.png", @"selectedImage",
                                 @"TarBarImageTitleUnselected.png", @"unselectedImage", nil],
                                nil];

    
    
    // Sub controller
    _subControllers = [[NSMutableArray alloc] init];

    UIViewController *backVC = [[UIViewController alloc] init];
    [_subControllers addObject:backVC];

    NSNumber *magazineId = self.dataObject;

    Result *result = [Magazine getDetail:magazineId];
    if (result.isSuccess && result.data != nil)
    {
        _magazine = result.data;
        if ([_magazine.images count] > 0)
        {

            self.magazineGalleryVC = [[MagazineGalleryViewController alloc] init];
            self.magazineGalleryVC.dataObject = _magazine;
            [_subControllers addObject:self.magazineGalleryVC];
            
            MagazineThumbImageViewController *thumbImageVC = [[MagazineThumbImageViewController alloc] init];
            thumbImageVC.magazineTabBarSwitchDelegate = self;
            thumbImageVC.dataObject = _magazine.images;
            [_subControllers addObject:thumbImageVC];
            
            MagazineImageTitleViewController *imageTitleVC = [[MagazineImageTitleViewController alloc] init];
            imageTitleVC.magazineTabBarSwitchDelegate = self;
            imageTitleVC.dataObject = _magazine;
            [_subControllers addObject:imageTitleVC];
            
        }
        
        
        
        
        // Tab bar background
        self.tabBar.backgroundColor = [UIColor clearColor];
        self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"Transparent.png"];
        
        // IOS5 is not support setShadowImage method
        if ([self respondsToSelector:@selector(setShadowImage:)])
        {
            self.tabBar.shadowImage = [UIImage imageNamed:@"TabBarShadow.png"];
        }
        
        self.tabBar.backgroundImage = [UIImage imageNamed:@"TabBarBackground.png"];
        
        
        
        // Tab bar button
        for (int i = 0; i < [self.tabBarButtonOptions count]; i++)
        {
            NSDictionary *dict = [self.tabBarButtonOptions objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(kTabBarButtonWidth * i,
                                         0.0f,
                                         kTabBarButtonWidth,
                                         self.tabBar.frame.size.height);
            if (i == 1)
            {
                imageView.image = [UIImage imageNamed:[dict objectForKey:@"selectedImage"]];
            }
            else
            {
                imageView.image = [UIImage imageNamed:[dict objectForKey:@"unselectedImage"]];
            }
            
            [self.tabBar insertSubview:imageView atIndex:i + 1];
        }
        
        self.viewControllers = _subControllers;
        self.selectedIndex = 1;
        self.delegate = self;
    }
    else
    {
        // Tab bar background
        self.tabBar.backgroundColor = [UIColor clearColor];
        self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"Transparent.png"];
        
        // IOS5 is not support setShadowImage method
        if ([self respondsToSelector:@selector(setShadowImage:)])
        {
            self.tabBar.shadowImage = [UIImage imageNamed:@"TabBarShadow.png"];
        }
        
        self.tabBar.backgroundImage = [UIImage imageNamed:@"TabBarBackground.png"];
        
        
        
        // Tab bar button
        for (int i = 0; i < 1; i++)
        {
            NSDictionary *dict = [self.tabBarButtonOptions objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(kTabBarButtonWidth * i,
                                         0.0f,
                                         kTabBarButtonWidth,
                                         self.tabBar.frame.size.height);
            if (i == 1)
            {
                imageView.image = [UIImage imageNamed:[dict objectForKey:@"selectedImage"]];
            }
            else
            {
                imageView.image = [UIImage imageNamed:[dict objectForKey:@"unselectedImage"]];
            }
            
            [self.tabBar insertSubview:imageView atIndex:i + 1];
        }
        
        self.viewControllers = _subControllers;
        self.selectedIndex = 1;
        self.delegate = self;
        
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _magazine = nil;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{    
    // Hide navigation bar
    self.navigationController.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{    
    // Show navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger currentIndex = [self.tabBar.items indexOfObject:item];
    if (currentIndex != self.selectedIndex)
    {
        // Get views. controllerIndex is passed in as the controller we want to go to.
        UIView *fromView = self.selectedViewController.view;
        UIView *toView = [[self.viewControllers objectAtIndex:currentIndex] view];

        // Transition using a page curl.
        [UIView transitionFromView:fromView
                            toView:toView
                          duration:0.5
                           options:(currentIndex > self.selectedIndex ?
                                    UIViewAnimationOptionTransitionFlipFromRight :
                                    UIViewAnimationOptionTransitionFlipFromLeft)
                        completion:^(BOOL finished) {
                            if (finished)
                            {
                                self.selectedIndex = currentIndex;
                            }
                        }
         ];
    
        // Reset select item icon
        for (int i = 0; i < [self.tabBarButtonOptions count]; i++)
        {
            NSDictionary *dict = [self.tabBarButtonOptions objectAtIndex:i];
            UIImageView *imageView = [self.tabBar.subviews objectAtIndex:i + 1];
            if (i == currentIndex)
            {
                imageView.image = [UIImage imageNamed:[dict objectForKey:@"selectedImage"]];
            }
            else
            {
                imageView.image = [UIImage imageNamed:[dict objectForKey:@"unselectedImage"]];
            }
        }
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UITabBarController *)viewController;
{
    if ([_subControllers indexOfObject:viewController] == 0)
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            [self.magazine refreshDownloadStatus];
        });
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)reloadTabBar
{
    UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:self.selectedIndex];
    [self tabBar:self.tabBar didSelectItem:tabBarItem];
}

- (void)setMagazineGallerySelectedIndex:(NSInteger)index
{
    self.gallerySelectedIndex = index;
}

- (void)tabBarSwitchButtonPress:(id)sender
{
    UIViewController *initialViewController = [self.magazineGalleryVC viewControllerAtIndex:self.gallerySelectedIndex];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.magazineGalleryVC.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];

    UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:1];
    [self tabBar:self.tabBar didSelectItem:tabBarItem];
}

@end