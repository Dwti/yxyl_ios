//
//  YXGuideViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/8/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGuideViewController.h"
#import "LoginViewController.h"

static NSString *const YXGuideViewShowedKey = @"kYXGuideViewShowedKey";

@interface YXGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation YXGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.image = [UIImage imageNamed:@"引导页的插画"];
    topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(420*kPhoneHeightRatio);
    }];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"全新界面";
    titleLabel.textColor = [UIColor colorWithHexString:@"336600"];
    titleLabel.font = [UIFont boldSystemFontOfSize:37];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(16*kPhoneHeightRatio);
        make.centerX.mas_equalTo(0);
    }];
    UILabel *subtitleLabel = [[UILabel alloc]init];
    subtitleLabel.text = @"轻松做题，让学习拥有美好的体验";
    subtitleLabel.textColor = [UIColor colorWithHexString:@"69ad0a"];
    subtitleLabel.font = [UIFont boldSystemFontOfSize:15];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:subtitleLabel];
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(16*kPhoneHeightRatio);
        make.centerX.mas_equalTo(0);
    }];
    UIButton *enterButton = [[UIButton alloc]init];
    [enterButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [enterButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
    enterButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [enterButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    enterButton.layer.cornerRadius = 6;
    enterButton.clipsToBounds = YES;
    [enterButton addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterButton];
    [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-40*kPhoneHeightRatio);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(165*kPhoneHeightRatio, 50*kPhoneHeightRatio));
    }];
    
}

- (void)enterAction {
    [self pushLoginViewController];
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

@end
