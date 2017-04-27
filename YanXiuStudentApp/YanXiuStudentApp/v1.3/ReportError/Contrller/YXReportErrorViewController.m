//
//  YXReportErrorController.m
//  YanXiuStudentApp
//
//  Created by wd on 15/11/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXReportErrorViewController.h"
#import "YXReportErrorViewModel.h"
#import "YXFeedbackView.h"
#import "YXCommonButton.h"

@interface YXReportErrorViewController ()

//@property (nonatomic, strong) YXFeedbackView    *reportContentView;
@property (nonatomic, strong) YXReportErrorViewModel   *viewModel;
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation YXReportErrorViewController

- (instancetype)initWithViewModel:(id)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self yx_setupLeftBackBarButtonItem];
    [self setupViews];
    [self setupViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private
- (void)setupViews
{
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"桌面"];
    [self.view addSubview:bgView];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    CGFloat width = self.view.bounds.size.width-70;
    UIImage *feedbackBgImage = [UIImage imageNamed:@"搜索列表背景"];
    feedbackBgImage = [feedbackBgImage stretchableImageWithLeftCapWidth:feedbackBgImage.size.width/2 topCapHeight:feedbackBgImage.size.height/2];
    UIImageView *feedbackBgView = [[UIImageView alloc]initWithImage:feedbackBgImage];
    feedbackBgView.userInteractionEnabled = YES;
    feedbackBgView.frame = CGRectMake(35, 25, width, 231);
    [scrollView addSubview:feedbackBgView];
    
    UIImage *textBgImage = [UIImage imageNamed:@"输入框背景"];
    textBgImage = [textBgImage stretchableImageWithLeftCapWidth:textBgImage.size.width/2 topCapHeight:textBgImage.size.height/2];
    UIImageView *textBgView = [[UIImageView alloc]initWithImage:textBgImage];
    textBgView.userInteractionEnabled = YES;
    textBgView.frame = CGRectMake(15, 15, width-30, 201);
    [feedbackBgView addSubview:textBgView];
    
    self.textView = [[SAMTextView alloc]initWithFrame:CGRectMake(10, 10, textBgView.bounds.size.width-20, textBgView.bounds.size.height-20)];
    self.textView.backgroundColor = [UIColor clearColor];
    NSString *placeholder = @"在这里输入您遇到的问题";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:placeholder];
    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, placeholder.length)];
    self.textView.attributedPlaceholder = attrString;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.clipsToBounds = YES;
    self.textView.textColor = [UIColor whiteColor];
    self.textView.layer.shadowColor = [UIColor colorWithHexString:@"bd8e00"].CGColor;
    self.textView.layer.shadowOffset = CGSizeMake(0, 1);
    self.textView.layer.shadowRadius = 0;
    self.textView.layer.shadowOpacity = 1;
    [textBgView addSubview:self.textView];
    
    YXCommonButton *sendButton = [[YXCommonButton alloc] initWithFrame:CGRectMake(35, feedbackBgView.frame.size.height+feedbackBgView.frame.origin.y+10, width, 61)];
    [sendButton setTitle:@"发 送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:sendButton];
}

- (void)setupViewModel
{
    @weakify(self);
    RAC(self,title) = RACObserve(self.viewModel, title);
    [self.textView.rac_textSignal subscribeNext:^(NSString * text) {
        @strongify(self);
        if (text && text.length > 500) {
            //            [self yx_showToast:@"达到500字上限！"];
            self.textView.text = [text substringToIndex:500];
        }
    }];
    
    RAC(self.viewModel,content) = self.textView.rac_textSignal;
    
    [[self.viewModel.reportErrorCommand errors] subscribeNext: ^(NSError* e) {
        @strongify(self);
        [self yx_stopLoading];
        [self yx_showToast:@"发送失败！"];
    }];
    [[self.viewModel.reportErrorCommand executionSignals] subscribeNext:^(RACSignal* signal) {
        [signal subscribeNext: ^(NSNumber * number) {
            @strongify(self);
            [self yx_stopLoading];
            [self yx_showToast:@"发送成功！"];
            [self performSelector:@selector(backToMyViewController) withObject:nil afterDelay:1];
        }];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        @strongify(self);
        if (!self) {
            return;
        }
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        CGFloat bottom = [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y;
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0);
    }];
}

- (void)backToMyViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendAction
{
    [self.textView resignFirstResponder];
    if (self.textView.text.length < 4) {
        [self yx_showToast:@"您的反馈字数太少啦！"];
        return;
    }
    [self yx_startLoading];
    [self.viewModel.reportErrorCommand execute:nil];
}


@end
