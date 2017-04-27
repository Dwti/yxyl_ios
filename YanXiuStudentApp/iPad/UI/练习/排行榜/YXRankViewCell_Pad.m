//
//  YXRankViewCell_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXRankViewCell_Pad.h"
#import "YXRankCellContainerView.h"

@interface YXRankViewCell_Pad()

@property (nonatomic, strong) YXRankCellContainerView *containerView;

@end

@implementation YXRankViewCell_Pad

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIImage *bgImage = [[UIImage imageNamed:@"排名背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
    self.backgroundView = [[UIImageView alloc] initWithImage:bgImage];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:bgImage];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _containerView = [[YXRankCellContainerView alloc] init];
    [self.contentView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setRankItem:(YXRankItem *)rankItem
{
    _rankItem = rankItem;
    [self.containerView setRankItem:rankItem];
}

@end
