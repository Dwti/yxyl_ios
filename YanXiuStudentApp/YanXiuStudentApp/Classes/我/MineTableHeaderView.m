//
//  MineTableHeaderView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MineTableHeaderView.h"

@interface MineTableHeaderView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UIImageView *pencilImageView;
@end

@implementation MineTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 0.02;
    self.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    
    self.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.image = [UIImage imageNamed:@"山和小鸟"];
    [self addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(75);
    }];
    UIImageView *headBgImageView = [[UIImageView alloc]init];
    headBgImageView.image = [UIImage imageNamed:@"头像外发光"];
    headBgImageView.userInteractionEnabled = YES;
    [self addSubview:headBgImageView];
    [headBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(115, 119));
    }];
    self.imageView = [[UIImageView alloc]init];
    self.imageView.backgroundColor = [UIColor colorWithHexString:@"cdfd34"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.cornerRadius = 37.5;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 5;
    self.imageView.clipsToBounds = YES;
    [headBgImageView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editAction)];
    [self.imageView addGestureRecognizer:tap];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:19];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"336600"];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headBgImageView.mas_right);
        make.top.mas_equalTo(38);
        make.right.mas_equalTo(-20).priorityHigh();
    }];
    UILabel *accountDescLabel = [[UILabel alloc]init];
    accountDescLabel.textColor = [UIColor colorWithHexString:@"336600"];
    accountDescLabel.font = [UIFont systemFontOfSize:13];
    accountDescLabel.text = @"账号 : ";
    [self addSubview:accountDescLabel];
    [accountDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headBgImageView.mas_right);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(10);
    }];
    self.accountLabel = [[UILabel alloc]init];
    self.accountLabel.font = [UIFont fontWithName:YXFontMetro_Medium size:14];
    self.accountLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.accountLabel];
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(accountDescLabel.mas_right);
        make.centerY.mas_equalTo(accountDescLabel.mas_centerY);
        make.right.mas_equalTo(-20).priorityHigh();
    }];
    UIButton *enterButton = [[UIButton alloc]init];
    [enterButton setImage:[UIImage imageNamed:@"绿底白色展开按钮"] forState:UIControlStateNormal];
    [self addSubview:enterButton];
    [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    self.pencilImageView = [[UIImageView alloc]init];
    self.pencilImageView.image = [UIImage imageNamed:@"铅笔人"];
    [self addSubview:self.pencilImageView];
    [self.pencilImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-60);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    UITapGestureRecognizer *enterTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterAction)];
    [self addGestureRecognizer:enterTap];
}

- (void)editAction {
    BLOCK_EXEC(self.editBlock);
}

- (void)enterAction {
    BLOCK_EXEC(self.enterBlock);
}

- (void)setHeadUrl:(NSString *)headUrl {
    _headUrl = headUrl;
    UIImage *placeholderImage = self.imageView.image? self.imageView.image:[UIImage imageNamed:@"我的页面的默认头像"];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:placeholderImage];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

- (void)setAccount:(NSString *)account {
    _account = account;
    self.accountLabel.text = account;
}

- (void)setOffsetRate:(CGFloat)offsetRate {
    _offsetRate = offsetRate;
    [self.pencilImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20*(1-offsetRate));
        make.right.mas_equalTo(-60+20*offsetRate);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

@end
