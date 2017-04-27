//
//  YXQAAnalysisReportErrorViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAAnalysisReportErrorViewController_Pad.h"
#import "YXCommonButton.h"
#import "YXQAErrorReportRequest.h"

@interface YXQAAnalysisReportErrorViewController_Pad ()
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YXQAErrorReportRequest  *reportErrorRequest;
@end

@implementation YXQAAnalysisReportErrorViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"题目报错";
    [self setupUI];
    [self setupObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupUI{
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"主面板-设置-背景"];
    [self.view addSubview:bgView];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    CGFloat width = self.view.bounds.size.width-150;
    UIImage *feedbackBgImage = [UIImage yx_resizableImageNamed:@"搜索列表背景"];
    UIImageView *feedbackBgView = [[UIImageView alloc]initWithImage:feedbackBgImage];
    feedbackBgView.userInteractionEnabled = YES;
    feedbackBgView.frame = CGRectMake(75, 25, width, 231);
    [scrollView addSubview:feedbackBgView];
    
    UIImage *textBgImage = [UIImage yx_resizableImageNamed:@"输入框背景"];
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
    [self.textView yx_setShadowWithColor:[UIColor colorWithHexString:@"bd8e00"]];
    [textBgView addSubview:self.textView];
    
    YXCommonButton *sendButton = [[YXCommonButton alloc] initWithFrame:CGRectMake(75, feedbackBgView.frame.size.height+feedbackBgView.frame.origin.y+10, width, 61)];
    [sendButton setTitle:@"发 送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:sendButton];
}

- (void)setupObservers{
    @weakify(self);
    [self.textView.rac_textSignal subscribeNext:^(NSString * text) {
        @strongify(self);
        if (!self) {
            return;
        }
        if (text && text.length > 500) {
            self.textView.text = [text substringToIndex:500];
        }
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

- (void)sendAction
{
    [self.textView resignFirstResponder];
    if (self.textView.text.length < 4) {
        [self yx_showToast:@"您的反馈字数太少啦！"];
        return;
    }

    [self.reportErrorRequest stopRequest];
    self.reportErrorRequest = [[YXQAErrorReportRequest alloc] init];
    self.reportErrorRequest.content = self.textView.text;
    self.reportErrorRequest.uid = [YXUserManager sharedManager].userModel.uid;
    self.reportErrorRequest.quesId = self.qid;
    [self yx_startLoading];
    @weakify(self);
    [self.reportErrorRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        if (!self) {
            return;
        }
        [self stopLoading];
        if (error) {
            [self yx_showToast:@"发送失败！"];
            return;
        }
        [self yx_showToast:@"发送成功！"];
        [self performSelector:@selector(naviLeftAction) withObject:nil afterDelay:1];
    }];

}
@end
