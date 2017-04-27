//
//  YXQAReportCorrectRateCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/5.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAReportCorrectRateCell.h"

@interface YXQAReportCorrectRateCell()
@property (nonatomic, strong) UILabel *correctRateLabel;
@end

@implementation YXQAReportCorrectRateCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.correctRateLabel = [[UILabel alloc]init];
    self.correctRateLabel.textAlignment = NSTextAlignmentCenter;
    self.correctRateLabel.font = [UIFont boldSystemFontOfSize:12];
    self.correctRateLabel.textColor = [UIColor colorWithHexString:@"118989"];
    [self.contentView addSubview:self.correctRateLabel];
    [self.correctRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (void)setCorrectRate:(CGFloat)correctRate{
    _correctRate = correctRate;
    NSString *rateStr = [NSString stringWithFormat:@"正确率 %.0f%@",correctRate*100,@"%"];
    self.correctRateLabel.text = rateStr;
}

@end
