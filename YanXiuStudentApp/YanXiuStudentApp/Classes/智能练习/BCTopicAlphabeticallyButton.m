//
//  BCTopicAlphabeticallyButton.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BCTopicAlphabeticallyButton.h"

@interface BCTopicAlphabeticallyButton ()
@property(nonatomic, strong) UILabel *descLabel;
@property(nonatomic, strong) UIImageView *positiveSequenceImageView;
@property(nonatomic, strong) UIImageView *invertedSequenceImageView;

@end

@implementation BCTopicAlphabeticallyButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.isFilter = YES;
        self.isPositiveSequence = YES;
    }
    return self;
}

- (void)setupUI {
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.font = [UIFont boldSystemFontOfSize:15.f];
    self.descLabel.text = @"字母排序";
    self.descLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX).offset(-11.f);
    }];
    
    self.invertedSequenceImageView = [[UIImageView alloc]init];
    self.invertedSequenceImageView.image = [UIImage imageNamed:@"倒序-未选择"];
    [self addSubview:self.invertedSequenceImageView];
    [self.invertedSequenceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_centerY).offset(-2.f);
        make.left.mas_equalTo(self.descLabel.mas_right).offset(10.f);
        make.size.mas_equalTo(CGSizeMake(9.f, 9.f));
    }];
    
    self.positiveSequenceImageView = [[UIImageView alloc]init];
    self.positiveSequenceImageView.image = [UIImage imageNamed:@"正序-未选择"];
    [self addSubview:self.positiveSequenceImageView];
    [self.positiveSequenceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).offset(2.f);
        make.left.mas_equalTo(self.invertedSequenceImageView);
        make.size.mas_equalTo(CGSizeMake(9.f, 9.f));
    }];
    
}

- (void)setIsFilter:(BOOL)isFilter {
    _isFilter = isFilter;
    if (isFilter) {
        self.descLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
    }else {
        self.isPositiveSequence = NO;
        self.descLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }
}

- (void)setIsPositiveSequence:(BOOL)isPositiveSequence {
    _isPositiveSequence = isPositiveSequence;
    if (self.isFilter) {
        if (isPositiveSequence) {
            self.positiveSequenceImageView.image = [UIImage imageNamed:@"正序-已选择"];
            self.invertedSequenceImageView.image = [UIImage imageNamed:@"倒序-未选择"];
        }else {
            self.positiveSequenceImageView.image = [UIImage imageNamed:@"正序-未选择"];
            self.invertedSequenceImageView.image = [UIImage imageNamed:@"倒序-已选择"];
        }
    }else {
        self.positiveSequenceImageView.image = [UIImage imageNamed:@"正序-未选择"];
        self.invertedSequenceImageView.image = [UIImage imageNamed:@"倒序-未选择"];
    }
}

@end
