//
//  YXWebViewController.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/17.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXWebViewController.h"
#import "YXCommonErrorView.h"

@interface YXWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *myWebView;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) YXCommonErrorView *errorView;

@end

@implementation YXWebViewController

- (instancetype)initWithUrl:(NSString *)url
{
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self yx_setupLeftBackBarButtonItem];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startLoadRequest];
}

- (void)startLoadRequest
{
    if (!self.url) {
        return;
    }
    NSURL *URL = [NSURL URLWithString:self.url];
    if (URL) {
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:URL]];
    }
}

- (UIWebView *)myWebView
{
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc] init];
        _myWebView.backgroundColor = [UIColor clearColor];
        _myWebView.dataDetectorTypes = 0;
        _myWebView.delegate = self;
        _myWebView.scalesPageToFit = YES;
        [self.view addSubview:_myWebView];
        [_myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(@0);
        }];
    }
    return _myWebView;
}

- (YXCommonErrorView *)errorView
{
    if (!_errorView) {
        _errorView = [[YXCommonErrorView alloc] init];
        @weakify(self);
        [_errorView setRetryBlock:^{
            @strongify(self); if (!self) return;
            [self startLoadRequest];
        }];
        [self.view addSubview:_errorView];
        [_errorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _errorView.hidden = YES;
    }
    return _errorView;
}

#pragma mark- UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self yx_startLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self yx_stopLoading];
    self.errorView.hidden = YES;
//    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    if (title.length > 0) {
//        self.title = title;
//    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self yx_stopLoading];
    self.errorView.hidden = NO;
}

@end
