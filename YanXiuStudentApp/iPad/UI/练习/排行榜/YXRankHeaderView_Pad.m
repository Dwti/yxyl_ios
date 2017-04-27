//
//  YXRankHeaderView_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXRankHeaderView_Pad.h"
#import "UIColor+YXColor.h"

@interface YXRankHeaderView_Pad ()

@property (nonatomic, strong) UILabel *rankLabel;

@end

@implementation YXRankHeaderView_Pad

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor yx_colorWithHexString:@"543b18"];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"我的排名背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30)]];
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    _rankLabel = [[UILabel alloc] init];
    _rankLabel.textColor = [UIColor colorWithHexString:@"006666"];
    _rankLabel.font = [UIFont boldSystemFontOfSize:14];
    _rankLabel.shadowColor = [UIColor colorWithHexString:@"33ffff"];
    _rankLabel.shadowOffset = CGSizeMake(0, 1);
    [self addSubview:_rankLabel];
    [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    
    UILabel *rightView = [[UILabel alloc] init];
    rightView.textAlignment = NSTextAlignmentRight;
    rightView.text = @"每周一重置，勤奋的同学都有机会登上榜首";
    rightView.textColor = [UIColor colorWithHexString:@"006666"];
    rightView.font = [UIFont systemFontOfSize:12];
    rightView.shadowColor = [UIColor colorWithHexString:@"33ffff"];
    rightView.shadowOffset = CGSizeMake(0, 1);
    [self addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(CGRectGetWidth(self.bounds)/2.f);
    }];
}

- (void)setRank:(NSString *)rank
{
    _rank = rank;
    if ([rank isEqualToString:@"0"] || rank.length == 0) {
        self.rankLabel.text = @"您的做题数过少，暂无排名";
        return;
    }
    self.rankLabel.text = [NSString stringWithFormat:@"我的排名：第%@位",rank];
}

@end
