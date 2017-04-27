//
//  YXRankCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/9/22.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXRankCell.h"
#import "YXRankCellContainerView.h"

@interface YXRankCell()

@property (nonatomic, strong) YXRankCellContainerView *containerView;

@end

@implementation YXRankCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setupUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
