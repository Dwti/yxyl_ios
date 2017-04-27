//
//  YXSchoolSearchCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/18.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXSchoolSearchCell.h"
#import "YXAreaSeperatorView.h"

@interface YXSchoolSearchCell()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation YXSchoolSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    YXAreaSeperatorView *sepView = [[YXAreaSeperatorView alloc]init];
    sepView.layer.shadowColor = [UIColor colorWithHexString:@"ffeb66"].CGColor;
    sepView.layer.shadowOffset = CGSizeMake(0, 1);
    sepView.layer.shadowRadius = 0;
    sepView.layer.shadowOpacity = 1;
    [self.contentView addSubview:sepView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.titleLabel.layer.shadowRadius = 0;
    self.titleLabel.layer.shadowOpacity = 1;
    [self.contentView addSubview:self.titleLabel];
    
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-20);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

@end
