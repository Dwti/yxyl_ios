//
//  MistakeQuestionHeaderView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MistakeQuestionHeaderView.h"

@interface MistakeQuestionHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MistakeQuestionHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"996600"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UIView *left = [[UIView alloc]init];
    left.backgroundColor = [UIColor colorWithHexString:@"ccc4a3"];
    [self addSubview:left];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.titleLabel.mas_left).mas_offset(-10);
    }];
    
    UIView *right = [[UIView alloc]init];
    right.backgroundColor = [UIColor colorWithHexString:@"ccc4a3"];
    [self addSubview:right];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(10);
        make.right.mas_equalTo(-20);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}
@end
