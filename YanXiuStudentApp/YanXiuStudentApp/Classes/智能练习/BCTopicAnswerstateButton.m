//
//  BCTopicAnswerstateButton.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BCTopicAnswerstateButton.h"

@interface BCTopicAnswerstateButton ()
@property(nonatomic, strong) UILabel *descLabel;
@property(nonatomic, strong) UIImageView *iconImageView;
@end

@implementation BCTopicAnswerstateButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.font = [UIFont boldSystemFontOfSize:15.f];
    self.descLabel.text = @"全部";
    self.descLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(-14.f);
    }];
    
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.image = [UIImage imageNamed:@"下拉展开-正常态"];
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.descLabel.mas_right).offset(12.f);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
    }];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.descLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
        if (self.isFilter) {
            self.iconImageView.image = [UIImage imageNamed:@"下拉收起-点击态"];
        }else {
           self.iconImageView.image = [UIImage imageNamed:@"下拉展开-点击态"];
        }
    }else {
        self.descLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.iconImageView.image = [UIImage imageNamed:@"下拉展开-正常态"];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.descLabel.text = title;
}

- (void)setIsFilter:(BOOL)isFilter {
    _isFilter = isFilter;
    if (isFilter) {
        if (self.selected) {
            self.iconImageView.image = [UIImage imageNamed:@"下拉收起-点击态"];
        }else {
            self.iconImageView.image = [UIImage imageNamed:@"下拉收起-正常态"];
        }
    }else {
        if (self.selected) {
            self.iconImageView.image = [UIImage imageNamed:@"下拉展开-点击态"];
        }else {
            self.iconImageView.image = [UIImage imageNamed:@"下拉展开-正常态"];
        }
    }
}


@end
