//
//  HomeworkAddClassView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "HomeworkAddClassView.h"
#import "ClassNumberInputView.h"
#import "LoginActionView.h"

@interface HomeworkAddClassView()
@property (nonatomic, strong) ClassNumberInputView *numberInputView;
@property (nonatomic, strong) LoginActionView *nextStepButton;
@property (nonatomic, strong) NSString *classNumberString;
@property (nonatomic, strong) UIScrollView *contentView;
@end

@implementation HomeworkAddClassView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupObservers];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    UIScrollView *contentView = [[UIScrollView alloc]init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.contentView = contentView;
    
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.backgroundColor = [UIColor redColor];
    topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(200*kPhoneWidthRatio);
        make.width.mas_equalTo(contentView.mas_width);
    }];
    self.numberInputView = [[ClassNumberInputView alloc]init];
    self.numberInputView.numberCount = 8;
    WEAK_SELF
    [self.numberInputView setTextChangeBlock:^(NSString *text){
        STRONG_SELF
        self.nextStepButton.isActive = !isEmpty(text);
        self.classNumberString = text;
    }];
    [contentView addSubview:self.numberInputView];
    [self.numberInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(85);
        make.left.mas_equalTo(35*kPhoneWidthRatio);
        make.right.mas_equalTo(-35*kPhoneWidthRatio);
        make.height.mas_equalTo(50);
    }];
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.text = @"请输入8位班级号";
    topLabel.textColor = [UIColor colorWithHexString:@"69ad0a"];
    topLabel.font = [UIFont systemFontOfSize:16];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(self.numberInputView.mas_top).mas_offset(-12);
    }];
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.text = @"同学，你需要先加入一个班级";
    promptLabel.textColor = [UIColor whiteColor];
    promptLabel.font = [UIFont boldSystemFontOfSize:18];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(8);
        make.centerX.mas_equalTo(0);
    }];
    LoginActionView *nextStepView = [[LoginActionView alloc]init];
    nextStepView.title = @"下一步";
    nextStepView.isActive = NO;
    [nextStepView setActionBlock:^{
        STRONG_SELF
        BLOCK_EXEC(self.nextStepBlock);
    }];
    [contentView addSubview:nextStepView];
    [nextStepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numberInputView.mas_left);
        make.right.mas_equalTo(self.numberInputView.mas_right);
        make.top.mas_equalTo(self.numberInputView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(50);
    }];
    self.nextStepButton = nextStepView;
    
    UIButton *skipButton = [[UIButton alloc]init];
    [skipButton setTitle:@"怎样加入班级?" forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor colorWithHexString:@"336600"] forState:UIControlStateHighlighted];
    [skipButton setImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 15, 15)] forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    [skipButton.titleLabel sizeToFit];
    skipButton.titleEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 18);
    skipButton.imageEdgeInsets = UIEdgeInsetsMake(0, skipButton.titleLabel.width+3, 0, -skipButton.titleLabel.width-3);
    [contentView addSubview:skipButton];
    [skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nextStepButton.mas_left);
        make.right.mas_equalTo(self.nextStepButton.mas_right);
        make.top.mas_equalTo(self.nextStepButton.mas_bottom).mas_offset(30);
        make.bottom.mas_equalTo(-40);
    }];
    
//    [self.numberInputView becomeFirstResponder];
}

- (void)setupObservers {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            self.contentView.contentInset = UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y, 0);
        }];
    }];
}

- (BOOL)becomeFirstResponder {
    return [self.numberInputView becomeFirstResponder];
}

- (void)skipAction {
    BLOCK_EXEC(self.helpBlock)
}

@end
