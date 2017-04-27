//
//  YXDifficultyCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/21.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXDifficultyCell.h"
#import "YXStarRateView.h"
#import "YXQADashLineView.h"

@interface YXDifficultyCell()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) YXStarRateView *rateView;
@end

@implementation YXDifficultyCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    YXQADashLineView *dashView = [[YXQADashLineView alloc]init];
    [self.contentView addSubview:dashView];
    [dashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(1);
    }];
    
    self.typeImageView = [[UIImageView alloc]init];
    self.typeImageView.contentMode = UIViewContentModeLeft;
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(60, 18));
    }];
    
    self.rateView = [[YXStarRateView alloc]initWithFrame:CGRectMake(0, 0, 95, 14)];
    [self.contentView addSubview:self.rateView];
    [self.rateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.typeImageView.mas_bottom).mas_offset(15);
        make.size.mas_equalTo(CGSizeMake(95, 14));
    }];
}


- (void)setItem:(YXQAAnalysisItem *)item{
    _item = item;
    self.typeImageView.image = [UIImage imageNamed:[item typeString]];
}

- (void)setDifficulty:(NSString *)difficulty{
    _difficulty = difficulty;
    CGFloat rate = difficulty.floatValue/5;
    self.rateView.scorePercent = rate;
}

+ (CGFloat)height{
    return 87;
}

@end
