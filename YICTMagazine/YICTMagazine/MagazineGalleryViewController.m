//
//  MagazineGalleryViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-22.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "MagazineGalleryViewController.h"
#import "Magazine.h"
#import "MagazineImageViewController.h"

@interface MagazineGalleryViewController ()

@property (nonatomic, strong) Magazine *magazine;
@property (nonatomic, strong) NSArray *magazineImageArray;

@end

@implementation MagazineGalleryViewController

@synthesize dataObject;

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

    
    
    // Data
    self.magazine = self.dataObject;
    self.magazineImageArray = self.magazine.images;
    
    
    
    // Images
    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.view.frame = self.view.bounds;
    
    
//    // Fix IOS7 compatibility
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        self.pageViewController.view.frame = CGRectMake(0.0,
//                                                        20.0,
//                                                        self.view.frame.size.width,
//                                                        self.view.frame.size.height - 20.0);
//    }
    
    
    MagazineImageViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];

    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    self.dataObject = nil;
//    self.magazine = nil;
//    self.magazineImageArray = nil;
}

- (void)back
{
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        [self.magazine refreshDownloadStatus];
    });
}

- (MagazineImageViewController *)viewControllerAtIndex:(NSInteger)index
{
    MagazineImage *magazineImage = [self.magazineImageArray objectAtIndex:index];
    MagazineImageViewController *childViewController = [[MagazineImageViewController alloc] initWithFrame:self.view.frame
                                                                                               dataObject:magazineImage
                                                                                                    index:index
                                                                                                viewCount:[self.magazineImageArray count]];
    childViewController.magazineImageViewDelegate = self;
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{    
    NSUInteger index = [(MagazineImageViewController *)viewController index];
    
    if (index == 0)
    {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{    
    NSUInteger index = [(MagazineImageViewController *)viewController index];
    
    index++;
    
    if (index == [self.magazineImageArray count])
    {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    // The number of items reflected in the page indicator.
//    return [self.magazineImageArray count];
    return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    // The selected item reflected in the page indicator.
    return 0;
}

- (void)doubleTaped:(id)sender
{
//    NSLog(@"doubleTaped");
//    NSLog(@"%@", sender);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
//        NSLog(@"%ul", gestureRecognizer.numberOfTouches);
//        gestureRecognizer = [[UITapGestureRecognizer alloc] init];
//        gestureRecognizer = 1
        
//        gestureRecognizer.new;

//
//        CGPoint touchPoint = [touch locationInView:self.view];
        
                return NO;
//
//        if (touchPoint.y < 40||touchPoint.y>360) { //Which position you want disable the gesture events.
//            return NO;
//        }
//        
    }
//    if ([[[touch.view class] description]isEqualToString:@"UISlider"]) {
//        return NO;
//    }
    return YES;
}

- (void)turnPrevious
{
    if ([self.pageViewController.childViewControllers count] > 0)
    {
        MagazineImageViewController *currentController = self.pageViewController.childViewControllers[0];
        UIViewController *previousController = [self pageViewController:self.pageViewController
                                                viewControllerBeforeViewController:currentController];
        if (previousController != nil)
        {
            NSArray *viewControllers = [NSArray arrayWithObject:previousController];
            [self.pageViewController setViewControllers:viewControllers
                                              direction:UIPageViewControllerNavigationDirectionReverse
                                               animated:YES
                                             completion:nil];
        }
    }
}

- (void)turnNext
{
    if ([self.pageViewController.childViewControllers count] > 0)
    {
        MagazineImageViewController *currentController = self.pageViewController.childViewControllers[0];
        UIViewController *nextController = [self pageViewController:self.pageViewController
                                     viewControllerAfterViewController:currentController];
        if (nextController != nil)
        {
            NSArray *viewControllers = [NSArray arrayWithObject:nextController];
            [self.pageViewController setViewControllers:viewControllers
                                              direction:UIPageViewControllerNavigationDirectionForward
                                               animated:YES
                                             completion:nil];
        }
    }
}

@end
