//
//  AboutViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "AboutViewController.h"
#import "PrivacyPolicyViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    topImageView.contentMode = UIViewContentModeScaleAspectFit;
    topImageView.image = [UIImage imageNamed:@"关于头图"];
    [self.contentView addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(200*kPhoneWidthRatio);
    }];
    UIView *containerView = [[UIView alloc]init];
    containerView.layer.cornerRadius = 6;
    containerView.clipsToBounds = YES;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(35*kPhoneWidthRatio);
        make.right.mas_equalTo(-35*kPhoneWidthRatio);
    }];
    UIView *wechatView = [self textItemViewWithTitle:@"官方微信" content:@"yixueyilian"];
    [containerView addSubview:wechatView];
    [wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    UIView *qqView = [self textItemViewWithTitle:@"QQ群" content:@"438863057"];
    [containerView addSubview:qqView];
    [qqView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(wechatView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(50);
    }];
    
    UIView *policyView = [self actionItemViewWithTitle:@"隐私政策"];
    policyView.layer.cornerRadius = 6;
    policyView.clipsToBounds = YES;
    [self.contentView addSubview:policyView];
    [policyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containerView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-40);
    }];
}

- (UIView *)textItemViewWithTitle:(NSString *)title content:(NSString *)content {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"69ad0a"];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"336600"];
    titleLabel.text = title;
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = [UIFont boldSystemFontOfSize:16];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.text = content;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
    return view;
}

- (UIView *)actionItemViewWithTitle:(NSString *)title {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"69ad0a"];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"336600"];
    titleLabel.text = title;
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    UIButton *b = [[UIButton alloc]init];
    [b setImage:[UIImage imageNamed:@"关于页面隐私政策按钮正常态"] forState:UIControlStateNormal];
    [b setImage:[UIImage imageNamed:@"关于页面隐私政策按钮点击态"] forState:UIControlStateHighlighted];
    [b addTarget:self action:@selector(goPrivacyPolicy) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:b];
    [b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(39);
    }];
    return view;
}

- (void)goPrivacyPolicy {
    PrivacyPolicyViewController *vc = [[PrivacyPolicyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
