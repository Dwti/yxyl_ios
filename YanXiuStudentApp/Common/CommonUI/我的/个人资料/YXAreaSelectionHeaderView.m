//
//  YXAreaSelectionHeaderView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXAreaSelectionHeaderView.h"

@interface YXAreaSelectionHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation YXAreaSelectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffdb4d"];
    UIImageView *tipImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tips-icon-yellow"]];
    [self.contentView addSubview:tipImageView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.titleLabel.layer.shadowRadius = 0;
    self.titleLabel.layer.shadowOpacity = 1;
    [self.contentView addSubview:self.titleLabel];
    
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tipImageView.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(0);
        make.right.mas_greaterThanOrEqualTo(-10);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

@end
