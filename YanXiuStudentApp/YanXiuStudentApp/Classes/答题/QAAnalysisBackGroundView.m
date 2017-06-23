//
//  QAAnalysisBackGroundView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisBackGroundView.h"
static const CGFloat kStateImgWidth = 157.0f;
static const CGFloat kStateImgHeight = 154.0f;

@interface QAAnalysisBackGroundView()
@end

@implementation QAAnalysisBackGroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    
    self.stateImgView = [[UIImageView alloc]init];
    [self addSubview:self.stateImgView];
    [self.stateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kStateImgWidth * kPhoneWidthRatio, kStateImgHeight * kPhoneWidthRatio));
    }];
}

- (void)setIsCorrect:(BOOL)isCorrect {
    _isCorrect = isCorrect;
    if (isCorrect) {
        self.stateImgView.image = [UIImage imageNamed:@"回答正确标签背景"];
    }else {
        self.stateImgView.image = [UIImage imageNamed:@"回答错误标签背景"];
    }
}
@end
