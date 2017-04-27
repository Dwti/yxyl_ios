//
//  SearchClassPromptView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/21/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "SearchClassPromptView.h"
#import "UIColor+YXColor.h"

@interface SearchClassPromptView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIView *underlineView;
@property (nonatomic, strong) EEAlertView *alertView;
@property (nonatomic, strong) EEAlertContentBackgroundImageView *bgView;
@property (nonatomic, strong) EEAlertTipImageView *tipImageView;
@property (nonatomic, strong) EEAlertDottedLineView *lineView;
@property (nonatomic, strong) EEAlertTitleLabel *titleLabel;
@property (nonatomic, strong) EEAlertButton *nextStepButton;

@end

@implementation SearchClassPromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //[self registerNotification];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    
    self.bgView = [[EEAlertContentBackgroundImageView alloc] init];
    
    self.tipImageView = [[EEAlertTipImageView alloc] init];
    
    self.titleLabel = [[EEAlertTitleLabel alloc] init];
    self.titleLabel.text = @"请输入 8 位数字班级号码 ^_^";
    
    self.lineView = [[EEAlertDottedLineView alloc] init];
    
    self.nextStepButton = [[EEAlertButton alloc] init];
    self.nextStepButton.enabled = NO;
    [self.nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    [[self.nextStepButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BLOCK_EXEC(self.nextAction);
    }];
    
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor:[UIColor yx_colorWithHexString:@"ffff99"]];
    [shadow setShadowOffset:CGSizeMake(0, 1)];
    
    NSDictionary *attrDict = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0],
                               NSForegroundColorAttributeName : [UIColor yx_colorWithHexString:@"805500"],
                               NSShadowAttributeName : shadow
                               };
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"没有班级可加，跳过此步" attributes: attrDict];
    self.skipButton = [[UIButton alloc] init];
    [self.skipButton setAttributedTitle:titleString forState:UIControlStateNormal];
    [[self.skipButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BLOCK_EXEC(self.skipAction);
    }];
    
    self.underlineView = [[UIView alloc] init];
    self.underlineView.backgroundColor = [UIColor yx_colorWithHexString:@"805500"];
    
    self.groupFiled = [[NumberInputView alloc] init];
    self.groupFiled.numberCount = 8;
    WEAK_SELF
    [self.groupFiled setTextChangeBlock:^(NSString *text) {
        STRONG_SELF
        self.nextStepButton.enabled = [[text yx_stringByTrimmingCharacters] length] == 8;
        self.text = text;
    }];
}

- (void)setupLayout {
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.containerView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.containerView addSubview:self.tipImageView];
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(15);
        make.top.equalTo(self.containerView).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipImageView.mas_right).offset(10);
        make.top.equalTo(self.tipImageView).offset(3);
        make.right.mas_lessThanOrEqualTo(self.containerView).offset(-20);
    }];
    
    [self.containerView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(5);
        make.right.equalTo(self.containerView).offset(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.containerView addSubview:self.groupFiled];
    [self.groupFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(20);
        make.right.equalTo(self.containerView).offset(-20);
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.height.mas_equalTo(36);
    }];
    
    [self.containerView addSubview:self.nextStepButton];
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(20);
        make.right.equalTo(self.containerView).offset(-20);
        make.top.equalTo(self.groupFiled.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
    }];
    
    [self.containerView addSubview:self.skipButton];
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nextStepButton.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(self.containerView).offset(-15);
    }];
    
    [self.containerView addSubview:self.underlineView];
    [self.underlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.skipButton.mas_width);
        make.top.equalTo(self.skipButton.mas_bottom).offset(-5);
        make.centerX.equalTo(self.skipButton);
        make.height.mas_equalTo(1);
    }];
}

//- (void)registerNotification {
//    WEAK_SELF
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] subscribeNext:^(id x) {
//        STRONG_SELF;
//        [self textDidChange];
//    }];
//}

//- (void)textDidChange {
//    [self resetButtonEnable];
//}
//
//- (void)resetButtonEnable {
//    self.nextStepButton.enabled = [[self.groupFiled.text yx_stringByTrimmingCharacters] length] == 8;
//}

@end
