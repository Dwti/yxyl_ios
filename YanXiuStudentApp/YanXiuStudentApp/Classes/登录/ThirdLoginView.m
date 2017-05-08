//
//  ThirdLoginView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ThirdLoginView.h"
#import "YXSSOAuthManager.h"

@interface ThirdLoginView()

@end

@implementation ThirdLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.text = @"其它账号登录";
    topLabel.textColor = [UIColor colorWithHexString:@"69ad0a"];
    topLabel.font = [UIFont systemFontOfSize:12];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    UIView *lv = [[UIView alloc]init];
    lv.backgroundColor = [UIColor colorWithHexString:@"7dbb24"];
    [self addSubview:lv];
    [lv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(topLabel.mas_left).mas_offset(-12);
        make.centerY.mas_equalTo(topLabel.mas_centerY);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    UIView *rv = [[UIView alloc]init];
    rv.backgroundColor = [UIColor colorWithHexString:@"7dbb24"];
    [self addSubview:rv];
    [rv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(topLabel.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(topLabel.mas_centerY);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    UIButton *qqButton = [[UIButton alloc]init];
    [qqButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [qqButton addTarget:self action:@selector(qqAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:qqButton];
    if ([YXSSOAuthManager isWXAppSupport]) {
        UIButton *weixinButton = [[UIButton alloc]init];
        [weixinButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        [weixinButton addTarget:self action:@selector(weixinAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:weixinButton];
        [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).mas_offset(-54);
            make.top.mas_equalTo(topLabel.mas_bottom).mas_offset(23);
            make.bottom.mas_equalTo(-23);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];
        [weixinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).mas_offset(54);
            make.top.mas_equalTo(qqButton.mas_top);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];
    }else {
        [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(topLabel.mas_bottom).mas_offset(23);
            make.bottom.mas_equalTo(-23);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];
    }
}

- (void)qqAction {
    BLOCK_EXEC(self.loginAction,ThirdLogin_QQ);
}

- (void)weixinAction {
    BLOCK_EXEC(self.loginAction,ThirdLogin_Weixin);
}

@end
