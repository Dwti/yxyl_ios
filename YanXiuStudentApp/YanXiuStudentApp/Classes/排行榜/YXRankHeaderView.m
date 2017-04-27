//
//  YXRankHeaderView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/9/22.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXRankHeaderView.h"
#import "UIColor+YXColor.h"

@interface YXRankHeaderView()

@property (nonatomic, strong) UILabel *rankLabel;

@end

@implementation YXRankHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundView = [[UIView alloc] init];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor yx_colorWithHexString:@"543b18"];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"我的排名背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30)]];
    [self.contentView addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.rankLabel = [[UILabel alloc] init];
    self.rankLabel.textColor = [UIColor colorWithHexString:@"006666"];
    self.rankLabel.font = [UIFont boldSystemFontOfSize:14];
    self.rankLabel.shadowColor = [UIColor colorWithHexString:@"33ffff"];
    self.rankLabel.shadowOffset = CGSizeMake(0, 1);
    [self.contentView addSubview:self.rankLabel];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
}

- (void)setRank:(NSString *)rank
{
    _rank = rank;
    if ([rank isEqualToString:@"0"]) {
        self.rankLabel.text = @"您的做题数过少，暂无排名";
        return;
    }
    self.rankLabel.text = [NSString stringWithFormat:@"我的排名：第%@位",rank];
}

@end
