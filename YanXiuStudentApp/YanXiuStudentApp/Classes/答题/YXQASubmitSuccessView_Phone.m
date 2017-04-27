//
//  YXQASubmitSuccessView_Phone.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/4/6.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQASubmitSuccessView_Phone.h"

@interface YXQASubmitSuccessView_Phone()
@property (nonatomic, strong) UILabel *instructionLabel;
@end

@implementation YXQASubmitSuccessView_Phone

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor colorWithHexString:@"fff0b2"];
    UIImageView *successImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"提交成功icon"]];
    [self addSubview:successImageView];
    
    UILabel *successLabel = [[UILabel alloc]init];
    successLabel.text = @"提交成功";
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.font = [UIFont boldSystemFontOfSize:20];
    successLabel.textColor = [UIColor colorWithHexString:@"805500"];
    [self addSubview:successLabel];
    
    UILabel *instructionLabel = [[UILabel alloc]init];
    instructionLabel.text = @"点击确定查看答案解析";
    instructionLabel.textAlignment = NSTextAlignmentCenter;
    instructionLabel.font = [UIFont systemFontOfSize:12];
    instructionLabel.textColor = [UIColor colorWithHexString:@"996600"];
    [self addSubview:instructionLabel];
    self.instructionLabel = instructionLabel;
    
    YXSmartDashLineView *dashView = [[YXSmartDashLineView alloc]init];
    dashView.lineColor = [UIColor colorWithHexString:@"e6bb47"];
    [self addSubview:dashView];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"ffe580"];
    [self addSubview:bottomView];
    
    UIButton *confirmButton = [[UIButton alloc]init];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"提交"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"提交-按下"] forState:UIControlStateHighlighted];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [confirmButton.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"ffff99"]];
    [confirmButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmButton];
    
    [successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(200);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(74, 74));
    }];
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(successImageView.mas_bottom).mas_offset(13);
    }];
    [instructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(successLabel.mas_bottom).mas_offset(40);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(90);
    }];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(175, 50));
    }];
    [dashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(bottomView.mas_top);
        make.height.mas_equalTo(1);
    }];
}

- (void)btnAction{
    BLOCK_EXEC(self.actionBlock);
    [self removeFromSuperview];
}

//- (void)setPType:(YXPType)pType{
//    _pType = pType;
//    if (pType == YXPTypeGroupHomework) {
//        self.instructionLabel.text = @"你已成功提交本次作业，请点击确定查看答案解析。";
//    }else{
//        self.instructionLabel.text = @"你已成功提交本次练习，请点击确定查看答案解析。";
//    }
//}
@end
