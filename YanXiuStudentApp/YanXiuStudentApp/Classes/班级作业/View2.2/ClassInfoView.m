//
//  ClassInfoView.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/12/21.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ClassInfoView.h"
#import "UIView+YXScale.h"
#import "YXCommonLabel.h"
#import "EEAlertView.h"

@implementation ClassInfoView

- (void)setData:(YXClassInfoMock *)data{
    _data = data;
    [self removeAllSubviews];
    [self setupUI];
}

- (void)setupUI{
    UIImageView *contentView = [UIImageView new];
    contentView.image = [[UIImage imageNamed:@"系统弹层背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 105, 40, 105)];
    contentView.userInteractionEnabled = YES;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
    }];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 266 * [UIView scale], 82 * [UIView scale])];
    [contentView addSubview:containerView];
    
    UIImageView *headerBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80 * [UIView scale], 80 * [UIView scale])];
    headerBGView.image = [[UIImage imageNamed:@"班级缩略图默认边框"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectInset(headerBGView.frame, 4.f, 4.f)];
    [headerView sd_setImageWithURL:self.data.iconUrl placeholderImage:[UIImage imageNamed:@"班级默认头像"]];
    [containerView addSubview:headerView];
    [containerView addSubview:headerBGView];
    
    CGFloat originX = CGRectGetMaxX(headerBGView.frame) + 15 * [UIView scale];
    YXCommonLabel *classNameLabel = [[YXCommonLabel alloc] initWithFrame:CGRectMake(originX, 0, CGRectGetWidth(containerView.bounds) - originX, 32 * [UIView scale])];
    classNameLabel.font = [UIFont boldSystemFontOfSize:17.f];
    classNameLabel.text = self.data.name;
    [containerView addSubview:classNameLabel];
    
    YXCommonLabel *classIdLabel = [[YXCommonLabel alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(classNameLabel.frame), CGRectGetWidth(classNameLabel.frame), 20 * [UIView scale])];
    classIdLabel.font = [UIFont systemFontOfSize:12.f];
    classIdLabel.text = [NSString stringWithFormat:@"班级号码：%@", self.data.gid];
    [containerView addSubview:classIdLabel];
    
    UIImage *textBGImage = [[UIImage imageNamed:@"标签背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 6, 10, 6)];
    UIImageView *teacherView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(classIdLabel.frame) + 8 * [UIView scale], 32 * [UIView scale], 18 * [UIView scale])];
    teacherView.image = textBGImage;
    [containerView addSubview:teacherView];
    
    UILabel *teacherLabel = [[UILabel alloc] initWithFrame:teacherView.bounds];
    teacherLabel.textAlignment = NSTextAlignmentCenter;
    teacherLabel.text = @"老师";
    teacherLabel.textColor = [UIColor colorWithRGBHex:0xffdb4d];
    teacherLabel.font = [UIFont systemFontOfSize:11.f];
    [teacherView addSubview:teacherLabel];
    
    YXCommonLabel *teacherNameLabel = [[YXCommonLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(teacherView.frame) + 10 * [UIView scale], CGRectGetMinY(teacherView.frame), 50 * [UIView scale], CGRectGetHeight(teacherView.frame))];
    teacherNameLabel.font = [UIFont boldSystemFontOfSize:13.f];
    teacherNameLabel.text = self.data.teacher;
    [containerView addSubview:teacherNameLabel];
    
    UIImageView *numberView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(teacherNameLabel.frame) + 10 * [UIView scale], CGRectGetMinY(teacherView.frame), 32 * [UIView scale], CGRectGetHeight(teacherView.frame))];
    numberView.image = textBGImage;
    [containerView addSubview:numberView];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:numberView.bounds];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = @"人数";
    numberLabel.textColor = teacherLabel.textColor;
    numberLabel.font = teacherLabel.font;
    [numberView addSubview:numberLabel];
    
    YXCommonLabel *studentNumberLabel = [[YXCommonLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numberView.frame) + 10 * [UIView scale], CGRectGetMinY(teacherView.frame), CGRectGetWidth(containerView.frame) - CGRectGetMaxX(numberView.frame) - 10 * [UIView scale], CGRectGetHeight(teacherView.frame))];
    studentNumberLabel.font = [UIFont boldSystemFontOfSize:13.f];
    studentNumberLabel.text = self.data.headcount;
    [containerView addSubview:studentNumberLabel];
    
    NSString *actionText = nil;
    switch (self.actionType) {
        case YXClassActionTypeJoin:
            actionText = @"申请加入";
            break;
        case YXClassActionTypeCancelJoining:
            actionText = @"取消申请";
            break;
        case YXClassActionTypeExit:
            actionText = @"退出班级";
            break;
    }
    
    EEAlertDottedLineView *line = [EEAlertDottedLineView new];
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset = 5;
        make.right.mas_equalTo(contentView).offset = -5;
        make.height.offset = 2;
        make.top.mas_equalTo(containerView.mas_bottom).offset = 20;
    }];
    
    EEAlertButton *button = [EEAlertButton new];
    [button setTitle:actionText forState:UIControlStateNormal];
    [contentView addSubview:button];
    CGFloat h = ((198 - 82 * [UIView scale]) - 40 - 50) / 2;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.right.offset = -20;
        make.height.offset = 40;
        //make.bottom.offset = -25;
        make.top.equalTo(line.mas_bottom).offset(h);
    }];
    self.button = button;
}

@end
