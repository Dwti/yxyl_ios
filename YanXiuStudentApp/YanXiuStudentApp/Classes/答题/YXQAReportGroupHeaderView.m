//
//  YXQAReportGroupHeaderView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/5.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAReportGroupHeaderView.h"

@interface YXQAReportGroupHeaderView()
@property (nonatomic, strong) UIImageView *titleImageView;
@end

@implementation YXQAReportGroupHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.titleImageView = [[UIImageView alloc]init];
    [self addSubview:self.titleImageView];
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(1, 15));
    }];
    
    UIView *left = [[UIView alloc]init];
    left.backgroundColor = [UIColor colorWithHexString:@"ccc4a3"];
    [self addSubview:left];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleImageView.mas_centerY);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.titleImageView.mas_left).mas_offset(-10);
    }];
    
    UIView *right = [[UIView alloc]init];
    right.backgroundColor = [UIColor colorWithHexString:@"ccc4a3"];
    [self addSubview:right];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleImageView.mas_centerY);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.titleImageView.mas_right).mas_offset(10);
        make.right.mas_equalTo(-20);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    UIImage *img = [UIImage imageNamed:title];
    self.titleImageView.image = img;
    [self.titleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(img.size);
    }];
}
@end
