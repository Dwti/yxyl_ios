//
//  YXQASubmitSuccessAndBackView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/4/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQASubmitSuccessAndBackView_Pad.h"

@interface YXQASubmitSuccessAndBackView_Pad()
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UILabel *endDateLabel;
@end

@implementation YXQASubmitSuccessAndBackView_Pad

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.maskView = [[UIView alloc]initWithFrame:self.bounds];
    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    [self addSubview:self.maskView];
    
    UIView *containerView = [[UIView alloc]init];
    containerView.backgroundColor = [UIColor colorWithHexString:@"fff0b2"];
    [self addSubview:containerView];
    
    UIImageView *successImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"提交成功icon"]];
    [containerView addSubview:successImageView];
    
    UILabel *successLabel = [[UILabel alloc]init];
    successLabel.text = @"提交成功";
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.font = [UIFont boldSystemFontOfSize:20];
    successLabel.textColor = [UIColor colorWithHexString:@"805500"];
    [containerView addSubview:successLabel];
    
    UILabel *dateInstructionLabel = [[UILabel alloc]init];
    dateInstructionLabel.textAlignment = NSTextAlignmentCenter;
    dateInstructionLabel.font = [UIFont systemFontOfSize:12];
    dateInstructionLabel.textColor = [UIColor colorWithHexString:@"996600"];
    dateInstructionLabel.text = @"本次作业被老师设置为：截止时间后显示答案解析";
    [containerView addSubview:dateInstructionLabel];
    
    self.endDateLabel = [[UILabel alloc]init];
    self.endDateLabel.textAlignment = NSTextAlignmentCenter;
    self.endDateLabel.font = [UIFont systemFontOfSize:12];
    self.endDateLabel.textColor = [UIColor colorWithHexString:@"996600"];
    [containerView addSubview:self.endDateLabel];
    
    UILabel *instructionLabel = [[UILabel alloc]init];
    instructionLabel.text = @"点击“确定”返回作业列表";
    instructionLabel.textAlignment = NSTextAlignmentCenter;
    instructionLabel.font = [UIFont systemFontOfSize:12];
    instructionLabel.textColor = [UIColor colorWithHexString:@"996600"];
    [containerView addSubview:instructionLabel];
    
    YXSmartDashLineView *dashView = [[YXSmartDashLineView alloc]init];
    dashView.lineColor = [UIColor colorWithHexString:@"e6bb47"];
    [containerView addSubview:dashView];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"ffe580"];
    [containerView addSubview:bottomView];
    
    UIButton *confirmButton = [[UIButton alloc]init];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"提交"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"提交-按下"] forState:UIControlStateHighlighted];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [confirmButton.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"ffff99"]];
    [confirmButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmButton];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(180);
        make.right.mas_equalTo(-180);
    }];
    [successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(220);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(74, 74));
    }];
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(successImageView.mas_bottom).mas_offset(13);
    }];
    [dateInstructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(successLabel.mas_bottom).mas_offset(40);
    }];
    [self.endDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(dateInstructionLabel.mas_bottom).mas_offset(8);
    }];
    [instructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.endDateLabel.mas_bottom).mas_offset(40);
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

- (void)setEndDate:(NSDate *)endDate{
    _endDate = endDate;
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateString = [formater stringFromDate:endDate];
    NSString *totalString = [NSString stringWithFormat:@"截止时间为：%@",dateString];
    self.endDateLabel.text = totalString;
}

@end
