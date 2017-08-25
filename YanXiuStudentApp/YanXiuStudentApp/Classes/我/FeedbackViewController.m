//
//  FeedbackViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "FeedbackViewController.h"
#import "YXFeedbackRequest.h"
#import "MineActionView.h"

@interface FeedbackViewController ()
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, strong) MineActionView *sendView;
@property (nonatomic, strong) YXFeedbackRequest *feedbackRequest;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"意见反馈";
    self.naviTheme = NavigationBarTheme_White;
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.textView = [[SAMTextView alloc]init];
    self.textView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.textView.font = [UIFont systemFontOfSize:17];
    self.textView.textColor = [UIColor colorWithHexString:@"333333"];
    NSString *placeholderStr = @"请描述您的意见或问题（200字以内）";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:placeholderStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"cccccc"] range:NSMakeRange(0, placeholderStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, placeholderStr.length)];
    self.textView.attributedPlaceholder = attrStr;
    self.textView.textContainerInset = UIEdgeInsetsMake(25, 15, 25, 15);
    self.textView.layer.shadowOffset = CGSizeMake(0, 1);
    self.textView.layer.shadowRadius = 1;
    self.textView.layer.shadowOpacity = 0.02;
    self.textView.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(265);
    }];
    
    self.sendView = [[MineActionView alloc]init];
    self.sendView.title = @"发 送";
    WEAK_SELF
    [self.sendView setActionBlock:^{
        STRONG_SELF
        [self sendFeedback];
    }];
    [self.contentView addSubview:self.sendView];
    [self.sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(30);
        make.size.mas_equalTo(CGSizeMake(250*kPhoneWidthRatio, 50));
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[self.textView rac_textSignal]subscribeNext:^(NSString *text) {
        STRONG_SELF
        if (text.length>200) {
            self.textView.text = [text substringWithRange:NSMakeRange(0, 200)];
        }
        self.sendView.isActive = text.length>0;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:17],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        self.textView.attributedText = [[NSAttributedString alloc] initWithString:self.textView.text attributes:attributes];
    }];
}

- (void)sendFeedback {
    [self.textView resignFirstResponder];
    if (self.textView.text.length<2) {
        [self.view nyx_showToast:@"请详细描述您的问题，至少2个字"];
        return;
    }
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.feedbackRequest stopRequest];
    self.feedbackRequest = [[YXFeedbackRequest alloc]init];
    self.feedbackRequest.content = self.textView.text;
    [self.feedbackRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.view.window nyx_showToast:@"发送成功"];
        [self backAction];
    }];
}

@end
