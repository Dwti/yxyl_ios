//
//  YXSideMenuCopyrightView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/26.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSideMenuCopyrightView_Pad.h"

@implementation YXSideMenuCopyrightView_Pad

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIImageView *logoView = [[UIImageView alloc]init];
    logoView.image = [UIImage imageNamed:@"版权logo"];
    [self addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(13, 21));
    }];
    
    UILabel *copyrightLabel = [[UILabel alloc]init];
    copyrightLabel.text = @"Copyright 2016 © SRT";
    copyrightLabel.font = [UIFont fontWithName:YXFontMetro_Medium size:12];
    copyrightLabel.textColor = [UIColor colorWithHexString:@"006666"];
    [copyrightLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"009494"]];
    [self addSubview:copyrightLabel];
    [copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logoView.mas_right).mas_offset(14);
        make.centerY.mas_equalTo(logoView.mas_centerY);
    }];
}

@end
