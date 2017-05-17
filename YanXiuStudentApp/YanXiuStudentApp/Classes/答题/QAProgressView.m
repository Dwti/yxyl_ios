//
//  QAProgressView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAProgressView.h"
#import "YXGradientView.h"

@interface QAProgressView()
@property (nonatomic, strong) UIView *barView;
@end

@implementation QAProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.barView = [[UIView alloc]init];
    self.barView.clipsToBounds = YES;
    [self addSubview:self.barView];
    
    UIColor *startColor = [UIColor colorWithHexString:@"89e00d"];
    UIColor *endColor = [UIColor colorWithHexString:@"ccff00"];
    YXGradientView *gradientView = [[YXGradientView alloc]initWithStartColor:startColor endColor:endColor orientation:YXGradientLeftToRight];
    gradientView.layer.cornerRadius = 1.5;
    gradientView.clipsToBounds = YES;
    [self.barView addSubview:gradientView];
    [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-2);
        make.top.bottom.right.mas_equalTo(0);
    }];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self.barView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(progress);
    }];
}

@end
