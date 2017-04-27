//
//  QAUnknownQuestionView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAUnknownQuestionView.h"

@implementation QAUnknownQuestionView

- (void)setupUI {
    [super setupUI];
    UILabel *lb = [[UILabel alloc]init];
    lb.text = @"加载中。。。";
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = [UIColor colorWithHexString:@"996600"];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

@end
