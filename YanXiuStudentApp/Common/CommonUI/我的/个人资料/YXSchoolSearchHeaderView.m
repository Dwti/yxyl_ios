//
//  YXSchoolSearchHeaderView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/18.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXSchoolSearchHeaderView.h"

@interface YXSchoolSearchHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation YXSchoolSearchHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffdb4d"];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"搜索结果";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.titleLabel.layer.shadowRadius = 0;
    self.titleLabel.layer.shadowOpacity = 1;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
}

@end
