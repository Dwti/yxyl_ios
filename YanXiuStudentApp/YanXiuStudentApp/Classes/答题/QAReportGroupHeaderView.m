//
//  QAReportGroupHeaderView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/21.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAReportGroupHeaderView.h"

@interface QAReportGroupHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation QAReportGroupHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(2.0f);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
@end
