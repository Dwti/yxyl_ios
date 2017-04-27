//
//  YXDetailViewController.m
//  YXUserStatistics
//
//  Created by ChenJianjun on 16/5/26.
//  Copyright © 2016年 yanxiu. All rights reserved.
//

#import "YXDetailViewController.h"
#import "NSObject+YXUserStatistics.h"

static NSString *const kIsFavKey = @"kIsFavKey";
static NSString *const kIsShareKey = @"kIsShareKey";

@interface YXDetailViewController ()

@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *favoriteButton;

@end

@implementation YXDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    shareButton.clipsToBounds = YES;
    shareButton.layer.cornerRadius = 2.f;
    shareButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    shareButton.layer.borderWidth = 1.f;
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [shareButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(onShareBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.shareButton = shareButton;
    
    UIButton *favoriteButton = [[UIButton alloc] init];
    favoriteButton.bounds = CGRectMake(0, 0, 100, 40);
    favoriteButton.center = self.view.center;
    favoriteButton.clipsToBounds = YES;
    favoriteButton.layer.cornerRadius = 2.f;
    favoriteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    favoriteButton.layer.borderWidth = 1.f;
    [favoriteButton setTitle:@"收藏" forState:UIControlStateNormal];
    [favoriteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [favoriteButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [favoriteButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [favoriteButton addTarget:self action:@selector(onFavBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:favoriteButton];
    self.favoriteButton = favoriteButton;
    [self sendUserStatisticsParams:[self loadLocalData]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onShareBtnPressed:(id)sender
{
    self.shareButton.selected = !self.shareButton.selected;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.shareButton.selected) forKey:kIsShareKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)onFavBtnPressed:(id)sender
{
    self.favoriteButton.selected = !self.favoriteButton.selected;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.favoriteButton.selected) forKey:kIsFavKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sendUserStatisticsParams:(NSDictionary *)params
{
    [super sendUserStatisticsParams:params];
    self.shareButton.selected = [[params objectForKey:kIsShareKey] boolValue];
    self.favoriteButton.selected = [[params objectForKey:kIsFavKey] boolValue];
}

- (NSDictionary *)loadLocalData
{
    NSMutableDictionary *localDict = [NSMutableDictionary dictionary];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kIsShareKey]) {
        localDict[kIsShareKey] = [[NSUserDefaults standardUserDefaults] objectForKey:kIsShareKey];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kIsFavKey]) {
        localDict[kIsFavKey] = [[NSUserDefaults standardUserDefaults] objectForKey:kIsFavKey];
    }
    return localDict;
}

@end
