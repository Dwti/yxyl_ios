//
//  YXPhotoEmptyView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/23.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXPhotoEmptyView.h"

@implementation YXPhotoEmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"主观题未做答icon"]];
    [self addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(55, 57));
    }];
    
    UILabel *lb = [[UILabel alloc]init];
    lb.text = @"这道题没有作答哦 >_<";
    lb.textColor = [UIColor colorWithHexString:@"666252"];
    lb.font = [UIFont systemFontOfSize:13];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconView.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(iconView.mas_centerY);
    }];
}

@end
