//
//  YXSideMenuNormalHeaderView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSideMenuNormalHeaderView_Pad.h"

@implementation YXSideMenuNormalHeaderView_Pad

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"008080"];
    UIView *v1 = [[UIView alloc]init];
    v1.backgroundColor = [UIColor colorWithHexString:@"007070"];
    [self.contentView addSubview:v1];
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    UIView *v2 = [[UIView alloc]init];
    v2.backgroundColor = [UIColor colorWithHexString:@"009494"];
    [self.contentView addSubview:v2];
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(v1.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}

@end
