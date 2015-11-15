//
//  NewsListViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-20.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#define kPageSize 20;
#define kTableHeaderViewHeight 44.0
#define kTableHeaderViewFrame CGRectMake(0.0, -kTableHeaderViewHeight, 320.0, kTableHeaderViewHeight)

#import "NewsListViewController.h"
#import "AppDelegate.h"
#import "News.h"
#import "NewsListViewCell.h"
#import "NewsDetailsViewController.h"
#import "DACircularProgressView.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface NewsListViewController ()

@property (nonatomic, retain) NSArray *yearArray;
@property (nonatomic, retain) NSMutableArray *newsArray;

@end

@implementation NewsListViewController

@synthesize sidebarDelegate;
@synthesize selectedYear;
@synthesize offset, limit, isLoadingData, isEnded, isBacked, isDecelerating;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // Title
    self.title = NSLocalizedString(@"News", nil);
    
    
    
    // Toggle sidebar button
    UIButton *toggleSidebarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleSidebarButton.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
    NSString *toggleSidebarOptionImageName = [NSString stringWithFormat:@"SidebarOptionButton.png"];
    UIImage *toggleSidebarOptionImage = [UIImage imageNamed:toggleSidebarOptionImageName];
    [toggleSidebarButton setImage:toggleSidebarOptionImage forState:UIControlStateNormal];
    [toggleSidebarButton addTarget:self action:@selector(toggleSidebar:)
                  forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sidebarOptionButton = [[UIBarButtonItem alloc]
                                            initWithCustomView:toggleSidebarButton];
    self.navigationItem.leftBarButtonItem = sidebarOptionButton;
    
    
    // Filter button
    UIButton *toggleFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *toggleFilterImage = [UIImage imageNamed:@"FilterIcon.png"];
    toggleFilterButton.frame = CGRectMake(0.0,
                                          0.0,
                                          toggleFilterImage.size.width,
                                          toggleFilterImage.size.height);
    [toggleFilterButton setImage:toggleFilterImage forState:UIControlStateNormal];
    [toggleFilterButton addTarget:self
                           action:@selector(toggleYearFilter)
                 forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toggleFilterOptionButton = [[UIBarButtonItem alloc] initWithCustomView:toggleFilterButton];
    self.navigationItem.rightBarButtonItem = toggleFilterOptionButton;
    
    
    // Table
    self.tableView.rowHeight = 86.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

    // Table header view
    Result *yearResult = [News getYearList];
    if (yearResult.isSuccess)
    {
        self.yearArray = yearResult.data;
        _headerView = [[UIView alloc] initWithFrame:kTableHeaderViewFrame];
        _headerView.hidden = YES;
        _yearScrollViewController = [[YearScrollViewController alloc] initWithFrame:kTableHeaderViewFrame
                                                                        ColumnWidth:self.view.frame.size.width / 3.0
                                                                          YearArray:self.yearArray
                                                                       SelectedYear:@-1];
        _yearScrollViewController.yearDelegate = self;
        [_headerView addSubview:_yearScrollViewController.view];
        [self.view addSubview:_headerView];

        
        // News
        self.selectedYear = @-1;
        self.offset = 0;
        self.limit = kPageSize;
        self.isEnded = NO;
    }
    else
    {
        _currentError = yearResult.error;
    }
    
    

    // Table footer view
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableFooterView.frame = CGRectMake(0.0,
                                                      0.0,
                                                      self.tableView.bounds.size.width,
                                                      self.tableView.rowHeight);

    
    // Reset table attributes
    self.tableView.contentInset = UIEdgeInsetsMake(0.0,
                                                   self.tableView.contentInset.left,
                                                   self.tableView.contentInset.bottom,
                                                   self.tableView.contentInset.right);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    
    
    // Lactivity indicator view
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
                                                      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.frame = self.tableView.tableFooterView.frame;
    activityIndicatorView.center = CGPointMake(self.tableView.tableFooterView.frame.size.width / 2,
                                               self.tableView.tableFooterView.frame.size.height / 2);
    [activityIndicatorView startAnimating];
    [self.tableView.tableFooterView addSubview:activityIndicatorView];
    self.tableView.tableFooterView.hidden = YES;

    
    
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
    
    
    _newsListImageQueue = dispatch_queue_create("NewsListImage", NULL);
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_currentError == nil)
    {
        if (self.selectedYear != nil && self.isBacked == NO)
        {
            Result *newsArrayResult = [News getList:self.selectedYear
                                isDisplayAtHomeView:NO
                                newsCategoryIdArray:nil
                                             offset:self.offset
                                              limit:self.limit];
            self.newsArray = newsArrayResult.data;
            [self.tableView reloadData];
            if ([self.newsArray count] < self.limit)
                
            {
                self.isEnded = YES;
            }
        }
        else
        {
            self.isBacked = NO;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    self.yearArray = nil;
//    self.newsArray = nil;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsListViewCellIdentifier";
    
//    static BOOL nibsRegistered = NO;
//    if (!nibsRegistered)
//    {
    UINib *nib = [UINib nibWithNibName:@"NewsListViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
//        nibsRegistered = YES;
//    }
    
    NewsListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[NewsListViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    
    
    // Configure the cell...
    // Background
    cell.backgroundView = [[UIView alloc] init];
    if (indexPath.row % 2 == 0)
    {
        cell.backgroundView.backgroundColor = [UIColor colorWithRed:(236.0 / 255.0)
                                                              green:(236.0 / 255.0)
                                                               blue:(236.0 / 255.0)
                                                              alpha:1.0];
    }
    else
    {
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    
    
    // Bind data
    cell.imageView.image = nil;
    cell.imageView.backgroundColor = [UIColor lightGrayColor];    
    News *news = [self.newsArray objectAtIndex:indexPath.row];
    
    if (news.thumbImageUrlString != nil && [news.thumbImageUrlString length] > 0)
    {
        DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
        progressView.center = CGPointMake(cell.imageView.frame.size.width / 2.0,
                                          cell.imageView.frame.size.height / 2.0);
        [cell.imageView addSubview:progressView];
        
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:news.thumbImageUrlString] options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
            [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (finished)
            {
                [progressView setProgress:1.0 animated:YES];
                cell.imageView.image = image;
                [progressView removeFromSuperview];
            }
        }];
    }
    
    cell.title = news.title;
    cell.dateString = news.releaseDate;
    if (news.categoryName != nil && [news.categoryName length] > 0)
    {
        cell.category = news.categoryName;
    }
    else
    {
        cell.categoryImageView.hidden = YES;
        cell.categoryLabel.hidden = YES;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailsViewController *newsDetailsVC = [[NewsDetailsViewController alloc] init];
    News *news = [self.newsArray objectAtIndex:indexPath.row];
    newsDetailsVC.dataObject = news.newsId;
    [self.navigationController pushViewController:newsDetailsVC animated:YES];
    self.isBacked = YES;
}

- (void)toggleSidebar:(id)sender
{
    [self.sidebarDelegate toggleSidebrButtonPressed:self];
}


#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    if (_headerView.hidden == NO && _isShowingFilter == NO)
    {
        _headerView.frame = CGRectMake(0.0,
                                       scrollView.contentOffset.y,
                                       self.view.frame.size.width,
                                       kTableHeaderViewHeight);
    }

    
    // Loading
    float height = self.tableView.rowHeight * [self.newsArray count];
    if (self.selectedYear != nil && !self.isLoadingData && !self.isEnded)
    {
        if (self.tableView.frame.size.height + scrollView.contentOffset.y >= height)
        {
            CGSize size = scrollView.contentSize;
            size.height = height + self.tableView.tableFooterView.frame.size.height;
            scrollView.contentSize = size;
            if (scrollView.contentOffset.y > 0)
            {
                self.tableView.tableFooterView.frame = CGRectMake(0.0,
                                                                  height,
                                                                  self.tableView.bounds.size.width,
                                                                  self.tableView.rowHeight);
            }
            else
            {
                self.tableView.tableFooterView.frame = CGRectMake(0.0,
                                                                  0.0,
                                                                  self.tableView.bounds.size.width,
                                                                  self.tableView.rowHeight);
            }
            self.tableView.tableFooterView.hidden = NO;
        }
    }
    else
    {
        CGSize size = scrollView.contentSize;
        size.height = height;
        self.tableView.tableFooterView.frame = CGRectMake(0.0,
                                                          self.tableView.rowHeight,
                                                          self.tableView.bounds.size.width,
                                                          self.tableView.rowHeight);
        self.tableView.tableFooterView.hidden = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isDecelerating = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(appendRows)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.isDecelerating = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isDecelerating = NO;
    [self appendRows];
}

- (void)appendRows
{
    if (_headerView.hidden == NO && _isShowingFilter == NO)
    {
        _headerView.frame = CGRectMake(0.0,
                                       self.tableView.contentOffset.y,
                                       self.view.frame.size.width,
                                       kTableHeaderViewHeight);
    }
    
    if (self.selectedYear != nil && !self.isLoadingData && !self.isEnded)
    {
        float height = self.tableView.rowHeight * [self.newsArray count];
        if (self.tableView.frame.size.height + self.tableView.contentOffset.y >= height)
        {
            self.isLoadingData = YES;
            CGSize size = self.tableView.contentSize;
            size.height = height + self.tableView.tableFooterView.frame.size.height;
            self.tableView.contentSize = size;
            self.tableView.tableFooterView.frame = CGRectMake(0.0,
                                                              height,
                                                              self.tableView.bounds.size.width,
                                                              self.tableView.rowHeight);
            self.tableView.tableFooterView.hidden = NO;
            
            NSInteger count = [self.newsArray count];
            self.offset += kPageSize;

            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, queue, ^{
                Result *result = [News getList:self.selectedYear
                           isDisplayAtHomeView:NO
                           newsCategoryIdArray:nil
                                        offset:self.offset
                                         limit:self.limit];

                dispatch_async(dispatch_get_main_queue(), ^{
                    if (result.data != nil)
                    {
                        NSInteger nextIndex = [self.newsArray count];
                        [self.tableView beginUpdates];
                        [self.newsArray addObjectsFromArray:result.data];
                        for (News *news in result.data)
                        {
                            NSIndexPath *path = [NSIndexPath indexPathForRow:nextIndex++ inSection:0];
                            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path]
                                                  withRowAnimation:UITableViewRowAnimationAutomatic];
                            
                        }
                        
                        [self.tableView endUpdates];
                    }
                    
                    _headerView.frame = CGRectMake(0.0,
                                                   self.tableView.contentOffset.y,
                                                   self.view.frame.size.width,
                                                   kTableHeaderViewHeight);
                    
                    
                    CGSize size = self.tableView.contentSize;
                    size.height = self.tableView.tableHeaderView.frame.size.height + self.tableView.rowHeight * [self.newsArray count];
                    self.tableView.contentSize = size;
                    self.tableView.tableFooterView.hidden = YES;
                    
                    self.isLoadingData = NO;
                    
                    if (count == [self.newsArray count] || count + self.limit > [self.newsArray count])
                    {
                        self.isEnded = YES;
                    }
                });
            });
        }
    }
}

- (void)tabPressed:(id)sender
{
    NSNumber *currentSelectedYear = sender;
    if ([currentSelectedYear isEqualToNumber:self.selectedYear] == false)
    {
        self.newsArray = [[NSMutableArray alloc] init];
        if (_headerView.hidden == NO)
        {
            _headerView.frame = CGRectMake(0.0,
                                           -kTableHeaderViewHeight,
                                           self.view.frame.size.width,
                                           kTableHeaderViewHeight);

        }
        
        self.tableView.tableFooterView.frame = CGRectMake(0.0,
                                                          self.tableView.rowHeight,
                                                          self.tableView.bounds.size.width,
                                                          self.tableView.rowHeight);
        self.tableView.tableFooterView.hidden = NO;
        self.tableView.contentOffset = CGPointZero;
        [self.tableView reloadData];
        
        self.isLoadingData = NO;
        self.isEnded = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.selectedYear = sender;
            self.offset = 0;
            Result *result = [News getList:self.selectedYear
                       isDisplayAtHomeView:NO
                       newsCategoryIdArray:nil
                                    offset:self.offset
                                     limit:self.limit];
            
            if (result.isSuccess)
            {
                self.newsArray = result.data;
                [self.tableView reloadData];
                self.tableView.tableFooterView.hidden = YES;
                self.tableView.contentOffset = CGPointMake(0.0, -kTableHeaderViewHeight);
                if ([self.newsArray count] < self.limit)
                {
                    self.isEnded = YES;
                }
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString((_currentError.code == 200 ? @"Warning" : @"Error"), nil)
                                                                    message:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey]
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        });
    }
}

- (void)toggleYearFilter
{
    __block BOOL isClosingFilter = NO;
    
    if (_headerView.hidden)
    {
        CGRect rect = kTableHeaderViewFrame;
        rect.origin.y = self.tableView.contentOffset.y - kTableHeaderViewHeight * 2.0;
        _headerView.frame = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        if (_headerView.hidden)
        {
            _isShowingFilter = YES;
            _headerView.hidden = !_headerView.hidden;
            CGRect rect = kTableHeaderViewFrame;
            rect.origin.y = self.tableView.contentOffset.y - kTableHeaderViewHeight;
            _headerView.frame = rect;
            
            self.tableView.contentInset = UIEdgeInsetsMake(kTableHeaderViewHeight,
                                                           self.tableView.contentInset.left,
                                                           self.tableView.contentInset.bottom,
                                                           self.tableView.contentInset.right);
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
            
            if (self.tableView.contentOffset.y >= 0.0)
            {
                self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x,
                                                           self.tableView.contentOffset.y - kTableHeaderViewHeight);
            }
        }
        else
        {
            _isShowingFilter = YES;

            CGRect rect = kTableHeaderViewFrame;
            rect.origin.y = self.tableView.contentOffset.y - kTableHeaderViewHeight * 2.0;
            _headerView.frame = rect;
            isClosingFilter = YES;
            
            self.tableView.contentInset = UIEdgeInsetsMake(0.0,
                                                           self.tableView.contentInset.left,
                                                           self.tableView.contentInset.bottom,
                                                           self.tableView.contentInset.right);
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        }
    } completion:^(BOOL finished) {
        if (isClosingFilter)
        {
            _headerView.hidden = !_headerView.hidden;
            isClosingFilter = NO;
        }
        
        _isShowingFilter = NO;
    }];
}

@end
