//
//  SchoolSearchAreaView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "SchoolSearchAreaView.h"
#import "PrefixHeader.pch"

@interface SchoolSearchAreaView()
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;
@end

@implementation SchoolSearchAreaView

- (instancetype)initWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district {
    if (self = [super init]) {
        self.province = province;
        self.city = city;
        self.district = district;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *descLabel = [[UILabel alloc]init];
    descLabel.text = @"范围：";
    descLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
    descLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(0);
    }];
    UILabel *provinceLabel = [descLabel clone];
    provinceLabel.text = self.province;
    [self addSubview:provinceLabel];
    [provinceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(descLabel.mas_right).mas_offset(0);
        make.centerY.mas_equalTo(descLabel.mas_centerY);
    }];
    UIView *dotView1 = [[UIView alloc]init];
    dotView1.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    dotView1.layer.cornerRadius = 1.5;
    [self addSubview:dotView1];
    [dotView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(provinceLabel.mas_right).mas_offset(7);
        make.centerY.mas_equalTo(provinceLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(3, 3));
    }];
    UILabel *cityLabel = [provinceLabel clone];
    cityLabel.text = self.city;
    [self addSubview:cityLabel];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(dotView1.mas_right).mas_offset(7);
        make.centerY.mas_equalTo(dotView1.mas_centerY);
    }];
    UIView *dotView2 = [dotView1 clone];
    [self addSubview:dotView2];
    [dotView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cityLabel.mas_right).mas_offset(7);
        make.centerY.mas_equalTo(cityLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(3, 3));
    }];
    UILabel *districtLabel = [provinceLabel clone];
    districtLabel.text = self.district;
    [self addSubview:districtLabel];
    [districtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(dotView2.mas_right).mas_offset(7);
        make.centerY.mas_equalTo(dotView2.mas_centerY);
//        make.right.mas_equalTo(0);
    }];
}

@end
