//
//  YXGuideViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/8/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGuideViewController.h"
#import "YXLoginViewController.h"
#import "LoginViewController.h"

static NSString *const YXGuideViewShowedKey = @"kYXGuideViewShowedKey";

@interface YXGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation YXGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat width = CGRectGetWidth(self.view.bounds);
    NSArray *images = @[@"引导1.png", @"引导2.png", @"引导3.png"];
    for (NSInteger index = 0; index < images.count; index++) {
        UIImage *image = [UIImage imageNamed:images[index]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(index * width, 0, width, height);
        [_scrollView addSubview:imageView];
    }
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.bounds) * images.count, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [YXGuideViewController setGuideShow:YES];
}

+ (BOOL)isGuideViewShowed
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:YXGuideViewShowedKey] boolValue];
}

+ (void)setGuideShow:(BOOL)isShowed
{
    [[NSUserDefaults standardUserDefaults] setObject:@(isShowed) forKey:YXGuideViewShowedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -

- (void)pushLoginViewController
{
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetFactor = (scrollView.contentSize.width - scrollView.contentOffset.x)/CGRectGetWidth(scrollView.bounds);
    if (offsetFactor <= 1) {
        [self pushLoginViewController];
    }
}

@end
