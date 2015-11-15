//
//  YearScrollViewController.m
//  YICTMagazine
//
//  Created by Seven on 13-8-20.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "YearScrollViewController.h"

@interface YearScrollViewController ()

@end

@implementation YearScrollViewController

@synthesize yearDelegate;
@synthesize _selectedYear;
@synthesize isDecelerating;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFrame:(CGRect)rect ColumnWidth:(int)columnWidth YearArray:(NSArray *)yearArray SelectedYear:(NSNumber *)selectedYear
{
    self = [super init];
	if (self)
    {
        _rect = rect;
        _columnWidth = columnWidth;
        _yearArray = [[NSMutableArray alloc] initWithObjects:@-1, nil];
        [_yearArray addObjectsFromArray:yearArray];
        _selectedYear = selectedYear;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0.0, 0.0, _rect.size.width, _rect.size.height);
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = CGRectMake(0.0,
                                      0.0,
                                      self.view.frame.size.width,
                                      self.view.frame.size.height);
    backgroundView.backgroundColor = [UIColor colorWithRed:(35.0/255.0)
                                                     green:(35.0/255.0)
                                                      blue:(35.0/255.0)
                                                     alpha:1.0];
    
    UIImageView *selectedImageView = [[UIImageView alloc] init];
    selectedImageView.image = [UIImage imageNamed:@"SelectedYearCell.png"];
    selectedImageView.frame = CGRectMake((self.view.frame.size.width - selectedImageView.image.size.width) / 2.0,
                                              self.view.frame.size.height - selectedImageView.image.size.height,
                                              selectedImageView.image.size.width,
                                              selectedImageView.image.size.height);
    [backgroundView addSubview:selectedImageView];
    [self.view insertSubview:backgroundView atIndex:0];
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cellPressed:(id)sender
{
    UIView *view = [sender view];
    NSInteger currentSelectedIndex = view.frame.origin.x / (_columnWidth + 1.0) - 1;
    [self scrollToSelectedIndex:currentSelectedIndex];
}

- (void)reloadData
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0,
                                                                0.0,
                                                                _rect.size.width,
                                                                _rect.size.height)];
//    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake((_columnWidth + 1.0) * ([_yearArray count] + 2.0),
                                         _rect.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    _scrollView.decelerationRate = 0.0;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.userInteractionEnabled = YES;

    for (NSInteger i = 0; i <= [_yearArray count]; i++)
    {
        if (i > 0)
        {
            NSNumber *year = [_yearArray objectAtIndex:i - 1];
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake((_columnWidth + 1.0) * i,
                                    0.0,
                                    _columnWidth + 1.0,
                                    _rect.size.height);
            view.userInteractionEnabled = YES;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _columnWidth, _rect.size.height)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18.0];
            if ([year isEqualToNumber:@-1])
            {
                titleLabel.text = NSLocalizedString(@"All", nil);
            }
            else
            {
                titleLabel.text = [year stringValue];
            }
            titleLabel.textAlignment = NSTextAlignmentCenter;
            if (year == _selectedYear)
            {
                titleLabel.textColor = [UIColor whiteColor];
            }
            else
            {
                titleLabel.textColor = [UIColor grayColor];
            }
            [view addSubview:titleLabel];

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellPressed:)];
            [tap setNumberOfTapsRequired:1];
            [tap setNumberOfTouchesRequired:1];
            [view addGestureRecognizer:tap];
            
            [_scrollView addSubview:view];
        }
	}
    
    [self.view insertSubview:_scrollView atIndex:1];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isDecelerating = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(switchTab)
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
    [self switchTab];
}

- (void)switchTab
{
    if (self.isDecelerating == NO)
    {
        NSInteger currentSelectedIndex = round(_scrollView.contentOffset.x / (_columnWidth + 1.0));
        [self scrollToSelectedIndex:currentSelectedIndex];
    }
}

- (void)scrollToSelectedIndex:(NSInteger)selectedIndex
{
    [UIView animateWithDuration:0.25 animations:^{
        _scrollView.contentOffset = CGPointMake(selectedIndex * (_columnWidth + 1.0), 0.0);
        for (NSInteger i = 0; i < [_yearArray count]; i++)
        {
            UIView *contentView = [_scrollView.subviews objectAtIndex:i];
            UILabel *titleLabel = [contentView.subviews objectAtIndex:0];
            if (i == selectedIndex)
            {
                titleLabel.textColor = [UIColor whiteColor];
            }
            else
            {
                titleLabel.textColor = [UIColor grayColor];
            }
        }
    } completion:^(BOOL isFinished) {
        if (isFinished)
        {
            _selectedYear = [_yearArray objectAtIndex:selectedIndex];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.yearDelegate tabPressed:_selectedYear];
            });
        }
    }];
}

@end
