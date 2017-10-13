//
//  PlayTopView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "PlayTopView.h"

@interface PlayTopView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation PlayTopView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"视频全屏－返回按钮"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"视频全屏－返回按钮点击态"] forState:UIControlStateHighlighted];
    [self addSubview:self.backButton];
    
    UIView *erectView = [[UIView alloc] init];
    erectView.backgroundColor = [UIColor colorWithHexString:@"5e5e5e"];
    [self addSubview:erectView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self addSubview:self.titleLabel];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5.0f);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
    }];
    
    [erectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_right).offset(15.0f);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_offset(16.0f);
        make.width.mas_offset(1.0f / [UIScreen mainScreen].scale);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(erectView.mas_right).offset(15.0f);
        make.centerY.equalTo(self.mas_centerY);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-20.0f);
    }];
    
}
- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titleLabel.text = titleString;
}
@end
