//
//  YXSideMenuNaviDateView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/26.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSideMenuNaviDateView_Pad.h"

@implementation YXSideMenuNaviDateView_Pad

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.font = [UIFont fontWithName:YXFontMetro_Bold size:16];
    dateLabel.textColor = [UIColor colorWithHexString:@"006666"];
    [dateLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"33ffff"]];
    [self addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
    
    UILabel *dayLabel = [[UILabel alloc]init];
    dayLabel.font = [UIFont fontWithName:YXFontMetro_Medium size:16];
    dayLabel.textColor = [UIColor colorWithHexString:@"006666"];
    [dayLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"33ffff"]];
    [self addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(dateLabel.mas_right).mas_offset(14);
        make.centerY.mas_equalTo(dateLabel.mas_centerY);
    }];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy. MM. dd"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    dateLabel.text = date;
    
    [formatter setDateFormat:@"cccc"];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    NSString *day = [formatter stringFromDate:[NSDate date]];
    dayLabel.text = day;
    
}



@end
