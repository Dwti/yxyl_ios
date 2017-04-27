//
//  YXPersonalInfoCell_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXPersonalInfoCell_Pad.h"


@interface YXPersonalInfoCell_Pad()
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation YXPersonalInfoCell_Pad

#pragma mark-

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"005959"];
    } else {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"007373"];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"007373"];
    _headerView = [[UIImageView alloc] init];
    [self.contentView addSubview:_headerView];
    
    self.portraitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"侧边栏头像边框"]];
    [self.contentView addSubview:self.portraitImageView];
    [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_portraitImageView.mas_top).mas_offset(4);
        make.left.mas_equalTo(_portraitImageView.mas_left).mas_offset(4);
        make.bottom.mas_equalTo(_portraitImageView.mas_bottom).mas_offset(-4);
        make.right.mas_equalTo(_portraitImageView.mas_right).mas_offset(-4);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"ffdb4d"];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.portraitImageView.mas_right).mas_offset(15).priorityHigh();
        make.top.mas_equalTo(25);
        make.right.mas_equalTo(-15);
    }];
    
    self.statusLabel = [[UILabel alloc]init];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"00dddd"];
    self.statusLabel.font = [UIFont systemFontOfSize:12];
    self.statusLabel.text = [NSString stringWithFormat:@"账号:%@",[YXUserManager sharedManager].userModel.mobile];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.portraitImageView.mas_right).mas_offset(15).priorityHigh();
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(7);
        make.right.mas_equalTo(-12);
    }];

}

- (void)reloadWithData:(YXUserModel *)data
{
    self.nameLabel.text = data.nickname;
    NSURL *URL = nil;
    if ([data.head yx_isHttpLink]) {
        URL = [NSURL URLWithString:data.head];
    }
    [self.headerView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"默认头像"]];
//    if ([YXQADataManager sharedInstance].hasDoExerciseToday) {
//        self.statusLabel.text = nil;
//    }else{
//        self.statusLabel.text = @"今天还未练习";
//    }
}

@end
