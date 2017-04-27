//
//  YXDistrictSelectionCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXDistrictSelectionCell.h"
#import "YXAreaSeperatorView.h"

@interface YXDistrictSelectionCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectImageView;
@end

@implementation YXDistrictSelectionCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.selectImageView.hidden = NO;
    }else{
        self.selectImageView.hidden = YES;
    }
    // Configure the view for the selected state
}

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
    
    self.selectImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"蓝色对勾"]];
    [self.contentView addSubview:self.selectImageView];
    
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.selectImageView.mas_left).mas_offset(-5);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

@end
