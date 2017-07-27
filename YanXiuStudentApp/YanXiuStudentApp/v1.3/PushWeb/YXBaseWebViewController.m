//
//  YXBaseWebViewController.m
//  YanXiuStudentApp
//
//  Created by wd on 15/11/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXBaseWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "YXCommonErrorView.h"

@interface YXBaseWebViewController ()<NJKWebViewProgressDelegate , UIWebViewDelegate>
@property (nonatomic, copy) NSString  *urlString;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIButton  *backButton;
@property (nonatomic, strong) UIButton  *closeButton;
@property (nonatomic, strong) UIButton  *refreshButton;

@property (nonatomic, strong) UILabel   *addressLabel;
@property (nonatomic, strong) NJKWebViewProgress    *webViewProgress;
@property (nonatomic, strong) NJKWebViewProgressView    *webViewProgressView;
@property (nonatomic, strong) YXCommonErrorView  *errorView;

@end

@implementation YXBaseWebViewController

- (instancetype)initWithUrlString:(NSString *)urlString
{
    if (self = [super init]) {
        _urlString = urlString;
        _showType = WebViewshowType_Push;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
    [self setupWebView];
    [self setupViews];
    [self setupRAC];
}

- (void)setupNavigationBar
{
    UIView * leftItemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    UIButton * backItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 44)];
    [backItem setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    
    self.backButton = backItem;
    [leftItemView addSubview:backItem];
    
    UIButton * closeItem = [[UIButton alloc]initWithFrame:CGRectMake(44+12, 0, 44, 44)];
    [closeItem setImage:[UIImage imageNamed:@"webViewClose"] forState:UIControlStateNormal];
    closeItem.hidden = YES;
    self.closeButton = closeItem;
    [leftItemView addSubview:closeItem];
    
    UIBarButtonItem * leftItemBar = [[UIBarButtonItem alloc]initWithCustomView:leftItemView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -26;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItemBar];
    
    UIButton * refreshItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 44)];
    [refreshItem setImage:[UIImage imageNamed:@"webRefreshPage_normal"] forState:UIControlStateNormal];
//    [refreshItem setImage:[UIImage imageNamed:@"webRefreshPage_select"] forState:UIControlStateHighlighted];
    self.refreshButton = refreshItem;
    
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshItem];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)setupRAC
{
    @weakify(self);
    self.backButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if (self.webView.canGoBack) {
            [self.webView goBack];
            self.closeButton.hidden = NO;
        }else{
            if (self.showType == WebViewshowType_Push) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
        }
        return [RACSignal empty];
    }];
    
    self.closeButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if (self.showType == WebViewshowType_Push) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        return [RACSignal empty];
    }];
    
    self.refreshButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if (![self.webView isLoading]) {
            [self.webView reload];
        }
        return [RACSignal empty];
    }];
}
- (void)setupWebView
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:webView];
    self.webView = webView;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0]];
    [self createAddressLabel];
}

- (void)createAddressLabel {
    UILabel * addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    addressLabel.font = [UIFont systemFontOfSize:12.f];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.addressLabel = addressLabel;
    [_webView insertSubview:self.addressLabel belowSubview:_webView.scrollView];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(13);
    }];
}

- (void)setAddressLabelText:(NSURLRequest *)request {
    NSString *webUrl = [[request URL] absoluteString];
    
    if ([webUrl isEqualToString:@"about:blank"]) {
        return;
    }
    
    NSString *titleTemp = [[request URL] host];
    
    if (titleTemp && titleTemp.length > 0) {
        titleTemp = webUrl;
    }else{
        titleTemp = @"";
    }
    [self.addressLabel setText:titleTemp];
}

- (void)setupViews
{
    NJKWebViewProgress * progress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = progress;
    progress.webViewProxyDelegate = self;
    progress.progressDelegate = self;
    self.webViewProgress = progress;
    
    NJKWebViewProgressView * progressView = [[NJKWebViewProgressView alloc] init];
    [self.view addSubview:progressView];
    self.webViewProgressView = progressView;
    [self.webViewProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.webView.mas_top).with.offset(2);
        make.height.mas_equalTo(2);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

- (void)setProgressViewProgress:(float)process {
    if (self.webViewProgressView != nil) {
        [self.webViewProgressView setProgress:process animated:YES];
    }
}

#pragma mark - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (self.webViewProgressView != nil) {
        [self.webViewProgressView setProgress:progress animated:YES];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.view nyx_startLoading];
    self.addressLabel.hidden = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
#if 0
    NSString *webUrl = [[request URL] absoluteString];
    if ([self.urlString isEqualToString:webUrl]) {
        //是第一次进来的
        [self setAddressLabelText:request];
    }
#endif
    [self setAddressLabelText:request];
    
    if (self.webView.canGoBack) {
        self.closeButton.hidden = NO;
    }

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.view nyx_stopLoading];
    self.errorView.hidden = YES;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.view nyx_stopLoading];
    self.errorView.hidden = NO;
}

- (YXCommonErrorView *)errorView
{
    if (!_errorView) {
        _errorView = [[YXCommonErrorView alloc] init];
        @weakify(self);
        [_errorView setRetryBlock:^{
            @strongify(self); if (!self) return;
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0]];
        }];
        [self.view addSubview:_errorView];
        [_errorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _errorView.hidden = YES;
    }
    return _errorView;
}

@end
