//
//  PrivacyPolicyViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/25.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()

@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTheme = NavigationBarTheme_White;
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.navigationItem.title = @"隐私政策";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIWebView *webView = [[UIWebView alloc]init];
    webView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mobile.hwk.yanxiu.com/privacy_policy.html"]]];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end
