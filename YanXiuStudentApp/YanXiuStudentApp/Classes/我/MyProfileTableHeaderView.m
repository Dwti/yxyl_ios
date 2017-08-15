//
//  MyProfileTableHeaderView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MyProfileTableHeaderView.h"

@interface MyProfileTableHeaderView()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation MyProfileTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 0.02;
    self.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.backgroundColor = [UIColor colorWithHexString:@"cdfd34"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.cornerRadius = 60;
    self.imageView.clipsToBounds = YES;
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editAction)];
    [self.imageView addGestureRecognizer:tap];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"编辑头像";
    label.font = [UIFont boldSystemFontOfSize:11];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [[UIColor colorWithHexString:@"89e00d"]colorWithAlphaComponent:0.94];
    [self.imageView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
}

- (void)editAction {
    BLOCK_EXEC(self.editBlock);
}

- (void)setHeadUrl:(NSString *)headUrl {
    _headUrl = headUrl;
    UIImage *placeholderImage = self.imageView.image? self.imageView.image:[UIImage imageNamed:@"个人资料中默认的头像"];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:placeholderImage];
}

@end
