//
//  PlayExceptionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "PlayExceptionView.h"

@interface PlayExceptionView ()
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation PlayExceptionView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.backgroundView = [[UIView alloc] init];
    [self addSubview:self.backgroundView];
    
    self.exceptionLabel = [[UILabel alloc] init];
    self.exceptionLabel.textColor = [UIColor whiteColor];
    self.exceptionLabel.font = [UIFont systemFontOfSize:14.0f];
    self.exceptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:self.exceptionLabel];
    
    self.exceptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exceptionButton.layer.cornerRadius = 6.f;
    self.exceptionButton.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    self.exceptionButton.layer.borderWidth = 1.0f;
    self.exceptionButton.clipsToBounds = YES;
    self.exceptionButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.exceptionButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
    [self.exceptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.exceptionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateHighlighted];
    [self.backgroundView addSubview:self.exceptionButton];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"视频全屏－返回按钮"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"视频全屏－返回按钮点击态"] forState:UIControlStateHighlighted];
    [self addSubview:self.backButton];
}

- (void)setupLayout {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_offset(85.0f);
    }];
    [self.exceptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundView.mas_centerX);
        make.top.equalTo(self.backgroundView.mas_top);
    }];
    [self.exceptionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(125.0f, 40.0f));
        make.centerX.equalTo(self.backgroundView.mas_centerX);
        make.top.equalTo(self.exceptionLabel.mas_bottom).offset(30.0f);
        make.bottom.equalTo(self.backgroundView.mas_bottom);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.size.mas_offset(CGSizeMake(50.0f, 50.0f));
    }];
}

@end
