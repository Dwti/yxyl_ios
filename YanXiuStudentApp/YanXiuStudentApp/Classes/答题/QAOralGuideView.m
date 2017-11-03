//
//  QAOralGuideView.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAOralGuideView.h"

@implementation QAOralGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"语音文字"]];
    topImageView.userInteractionEnabled = YES;
    [self addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(215, 104));
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"语音操作提示"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(topImageView.mas_bottom).offset(22);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
}

- (void)btnAction:(UIButton *)sender {
    BLOCK_EXEC(self.btnClickBlock);
}

@end
