//
//  QAReportErrorViewController.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/29.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAReportErrorViewController.h"
#import "QAReportErrorOptionView.h"
#import "QASubmitButton.h"
#import "YXQAErrorReportRequest.h"

static const CGFloat kErrorOptionViewHeight = 224.0f;
static const CGFloat ktextViewHeight = 200.f;

@interface QAReportErrorViewController ()<UITextViewDelegate>
@property (nonatomic, strong) QAReportErrorOptionView *errorOptionView;
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, strong) UIView *submitView;
@property (nonatomic, strong) QASubmitButton *submitButton;
@property (nonatomic, strong) YXQAErrorReportRequest  *reportErrorRequest;

@end

@implementation QAReportErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"题目报错";
    [self setupUI];
    [self setupLayout];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.translucent = NO;
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.translucent = YES;
    [navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.naviTheme = NavigationBarTheme_White;
    
    self.errorOptionView = [[QAReportErrorOptionView alloc]init];
    WEAK_SELF
    [self.errorOptionView setErrorOptionChangeBlock:^{
        STRONG_SELF
        [self resetSubmitButtonEnable];
    }];
    
    self.textView = [[SAMTextView alloc]init];
    [self.textView setTintColor:[UIColor colorWithHexString:@"89e00d"]];
    NSString *placeholder = @"请输入错误详情 (200字以内)";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:placeholder];
    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"cccccc"],NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} range:NSMakeRange(0, placeholder.length)];
    self.textView.attributedPlaceholder = attrString;
    self.textView.font = [UIFont systemFontOfSize:17];
    self.textView.textColor = [UIColor colorWithHexString:@"333333"];
    self.textView.textContainerInset = UIEdgeInsetsMake(23, 10, 15, 15);
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.layer.shadowOffset = CGSizeMake(0, 2.5);
    self.textView.layer.shadowRadius = 2.5;
    self.textView.layer.shadowOpacity = 0.02;
    self.textView.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    
    self.submitView = [[UIView alloc]init];
    self.submitView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    
    self.submitButton = [[QASubmitButton alloc]init];
    self.submitButton.title = @"提交";
    [self resetSubmitButtonEnable];
    [self.submitButton setSubmitBlock:^{
        STRONG_SELF
        [self reportError];
    }];
}

- (void)setupLayout {
    [self.contentView addSubview:self.errorOptionView];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.submitView];
    [self.submitView addSubview:self.submitButton];
    
    [self.errorOptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kErrorOptionViewHeight);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.errorOptionView.mas_bottom);
        make.height.mas_equalTo(ktextViewHeight);
    }];
    CGFloat height = SCREEN_HEIGHT - kErrorOptionViewHeight - ktextViewHeight;
    if (height < 110.f) {
        height = 110.f;
    }
    [self.submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(250 *kPhoneWidthRatio, 50));
    }];
}

- (void)resetSubmitButtonEnable {
    if (self.errorOptionView.optionSelectedArray.count > 0 || [self.textView.text yx_isValidString]) {
        self.submitButton.enabled = YES;
        return;
    }
    self.submitButton.enabled = NO;
}

- (void)reportError {
    if (self.reportErrorRequest) {
        [self.reportErrorRequest stopRequest];
    }
    self.reportErrorRequest = [[YXQAErrorReportRequest alloc] init];
    self.reportErrorRequest.content = self.textView.text;
    self.reportErrorRequest.uid = [YXUserManager sharedManager].userModel.uid;
    self.reportErrorRequest.quesId = self.questionID;
    __block NSString *type = [NSString string];
    [self.errorOptionView.optionSelectedArray enumerateObjectsUsingBlock:^(QAReportErrorOption * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.errorOptionView.optionSelectedArray.count - 1) {
            type = [type stringByAppendingString:[NSString stringWithFormat:@"%@,",obj.title]];
        }
        if (idx == self.errorOptionView.optionSelectedArray.count - 1) {
            type = [type stringByAppendingString:obj.title];
        }
    }];
    self.reportErrorRequest.type = type;
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.reportErrorRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - textView delegate
- (void)textViewDidChange:(UITextView *)textView {
    NSString *content = textView.text;
    if (content.length > 200) {
        textView.text =  [content substringToIndex:200];
    }
    [self resetSubmitButtonEnable];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end

