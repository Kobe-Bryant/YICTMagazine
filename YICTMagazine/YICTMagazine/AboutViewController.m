//
//  AboutViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-9-7.
//  Copyright (c) 2013年 YICT. All rights reserved.
//
#define kDetailX 13.0f

#import "AboutViewController.h"
#import "About.h"

@interface AboutViewController ()

@property (nonatomic, weak) NSError *currentError;

@end

@implementation AboutViewController

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
	// Do any additional setup after loading the view.
    // Title
    self.title = NSLocalizedString(@"About Us", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    // Navigation bar back button
    UIImage *backButtonImage = [UIImage imageNamed:@"Back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    
    // Scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:scrollView];
    
    
    // Content
    
    
//    UIWebView *webView = [[UIWebView alloc] init];
//    webView.frame = CGRectMake(0.0f,
//                               0.0f,
//                               self.view.frame.size.width,
//                               self.view.frame.size.height);
//    webView.backgroundColor = [UIColor whiteColor];
////    webView.delegate = self;
//    webView.scrollView.scrollEnabled = YES;
//    NSString *contents = [[NSString alloc] init];
//    contents = [contents stringByAppendingString:@"<style type=\"text/css\">\n"];
//    contents = [contents stringByAppendingString:@"body { color: rgb(102, 102, 102); }\n"];
//    contents = [contents stringByAppendingString:@"</style>\n"];
//    
    Result *result = [About getInfo];
    if (result.isSuccess)
    {
        About *about = result.data;
        if (about.contents != nil)
        {
//            contents = [contents stringByAppendingString:about.contents];
//            [webView loadHTMLString:contents baseURL:nil];
//            [self.view addSubview:webView];
            UILabel *detailsLabel = [[UILabel alloc] init];
            detailsLabel.frame = CGRectMake(kDetailX,
                                            kDetailX,
                                            self.view.frame.size.width - kDetailX * 2,
                                            self.view.frame.size.height);
            detailsLabel.textColor = [UIColor colorWithRed:(102.0f / 255.0f)
                                                     green:(102.0f / 255.0f)
                                                      blue:(102.0f / 255.0f)
                                                     alpha:1.0f];
            detailsLabel.font = [UIFont systemFontOfSize:16.0];
            detailsLabel.lineBreakMode = NSLineBreakByWordWrapping;
            detailsLabel.numberOfLines = 0;
            detailsLabel.text = about.contents;
            [detailsLabel sizeToFit];
            [scrollView addSubview:detailsLabel];
            
            CGSize size = scrollView.frame.size;
            size.height = detailsLabel.frame.size.height + 100.0f;
            [scrollView setContentSize:size];
        }
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIScrollView *scrollView = [self.view.subviews objectAtIndex:0];
    scrollView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(void)back
{
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    CGRect rect = webView.frame;
//    rect.size.height = webView.scrollView.contentSize.height + 100.0f;
//    webView.frame = rect;
//    NSLog(@"webViewDidFinishLoad");
//}

@end
