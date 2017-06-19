//
//  QAAnswerDetailsCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnswerDetailsCell.h"

@interface QAAnswerDetailsCell ()
@property (nonatomic, strong) UILabel *answerDetailsLabel;
@end

@implementation QAAnswerDetailsCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.answerDetailsLabel = [[UILabel alloc]init];
    self.answerDetailsLabel.backgroundColor = [UIColor colorWithHexString:@"fefefe"];
    self.answerDetailsLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    self.answerDetailsLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.answerDetailsLabel.textAlignment = NSTextAlignmentCenter;
    self.answerDetailsLabel.text = @"作答详情";
    [self addSubview:self.answerDetailsLabel];
    [self.answerDetailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
@end
