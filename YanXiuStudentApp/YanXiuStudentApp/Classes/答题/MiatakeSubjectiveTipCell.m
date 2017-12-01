//
//  MiatakeSubjectiveTipCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/12/1.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MiatakeSubjectiveTipCell.h"

@interface MiatakeSubjectiveTipCell()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation MiatakeSubjectiveTipCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];

    self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"提醒图标"]];
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(18.f);
        make.size.mas_equalTo(CGSizeMake(16.f, 16.f));
    }];
    
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.font = [UIFont systemFontOfSize:13.f];
    self.tipLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.text = @"本题不支持在线作答\n请在纸上解答后,点击\"查看解析\"自行校对答案";
    [self.contentView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(10.f);
        make.centerX.mas_equalTo(0);
    }];
}

@end
