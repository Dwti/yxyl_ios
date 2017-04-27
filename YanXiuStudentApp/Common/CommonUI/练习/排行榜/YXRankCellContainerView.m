//
//  YXRankCellContainerView.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/26.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXRankCellContainerView.h"
#import "YXCommonLabel.h"
#import "UIColor+YXColor.h"
#import "UIView+YXScale.h"
#import "YXEdgeLabel.h"
#import "YXRankModel.h"

@interface YXRankCellContainerView()

@property (nonatomic, strong) UIImageView *rankNumberView;
@property (nonatomic, strong) YXEdgeLabel *rankNumberLabel;
@property (nonatomic, strong) UIImageView *headerBGView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) YXCommonLabel *nameLabel;
@property (nonatomic, strong) YXCommonLabel *schoolLabel;
@property (nonatomic, strong) UILabel *answerNumberTipLabel;
@property (nonatomic, strong) YXCommonLabel *answerNumberLabel;
@property (nonatomic, strong) UILabel *correctRateTipLabel;
@property (nonatomic, strong) YXCommonLabel *correctRateLabel;
@property (nonatomic, strong) UIImageView *firstThreeRankView;

@end

@implementation YXRankCellContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _headerView = [[UIImageView alloc] init];
        _headerView.clipsToBounds = YES;
        [self addSubview:_headerView];
        
        _headerBGView = [[UIImageView alloc] init];
        [self addSubview:_headerBGView];
        
        _rankNumberView = [[UIImageView alloc] init];
        [self addSubview:_rankNumberView];
        
        _rankNumberLabel = [[YXEdgeLabel alloc] init];
        _rankNumberLabel.textAlignment = NSTextAlignmentCenter;
        _rankNumberLabel.textColor = [UIColor whiteColor];
        _rankNumberLabel.font = [UIFont fontWithName:YXFontArial size:11.f];
        [self addSubview:_rankNumberLabel];
        
        _nameLabel = [[YXCommonLabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:_nameLabel];
        
        _schoolLabel = [[YXCommonLabel alloc] init];
        _schoolLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_schoolLabel];
        
        _answerNumberTipLabel = [[UILabel alloc] init];
        _answerNumberTipLabel.backgroundColor = yx_colorWithRGB(108, 67, 2);
        _answerNumberTipLabel.text = @"答题数";
        _answerNumberTipLabel.textAlignment = NSTextAlignmentCenter;
        _answerNumberTipLabel.clipsToBounds = YES;
        _answerNumberTipLabel.layer.cornerRadius = 2.f;
        _answerNumberTipLabel.textColor = [UIColor yx_colorWithHexString:@"ffdb4d"];
        _answerNumberTipLabel.font = [UIFont boldSystemFontOfSize:10.f];
        [self addSubview:_answerNumberTipLabel];
        
        _answerNumberLabel = [[YXCommonLabel alloc]init];
        _answerNumberLabel.font = [UIFont fontWithName:YXFontMetro_Bold size:15.f];
        [self addSubview:_answerNumberLabel];
        
        _correctRateTipLabel = [[UILabel alloc] init];
        _correctRateTipLabel.backgroundColor = yx_colorWithRGB(12, 97, 95);
        _correctRateTipLabel.text = @"正确率";
        _correctRateTipLabel.textAlignment = NSTextAlignmentCenter;
        _correctRateTipLabel.clipsToBounds = YES;
        _correctRateTipLabel.layer.cornerRadius = 2.f;
        _correctRateTipLabel.textColor = [UIColor yx_colorWithHexString:@"ffdb4d"];
        _correctRateTipLabel.font = [UIFont boldSystemFontOfSize:10.f];
        [self addSubview:_correctRateTipLabel];
        
        _correctRateLabel = [[YXCommonLabel alloc]init];
        _correctRateLabel.font = _answerNumberLabel.font;
        _correctRateLabel.textColor = [UIColor colorWithHexString:@"007373"];
        [self addSubview:_correctRateLabel];
        
        _firstThreeRankView = [[UIImageView alloc] init];
        [self addSubview:_firstThreeRankView];
        
        [_headerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(70);
            make.left.mas_equalTo(23 * [UIView scale]);
            make.top.mas_equalTo(17);
        }];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(62);
            make.left.mas_equalTo(27 * [UIView scale]);
            make.top.mas_equalTo(21);
        }];
        
        [_rankNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10 * [UIView scale]);
            make.top.mas_equalTo(7);
            make.height.width.mas_equalTo(30);
        }];
        
        [_rankNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10 * [UIView scale]);
            make.top.mas_equalTo(7);
            make.height.width.mas_equalTo(30);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headerBGView.mas_right).mas_offset(15 * [UIView scale]);
            make.top.mas_equalTo(15);
            make.right.mas_equalTo(-15 * [UIView scale]);
        }];
        
        [_schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headerBGView.mas_right).mas_offset(15 * [UIView scale]);
            make.top.mas_equalTo(_nameLabel.mas_bottom).mas_offset(8);
            make.right.mas_equalTo(-15 * [UIView scale]);
        }];
        
        [_answerNumberTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headerBGView.mas_right).mas_offset(15 * [UIView scale]);
            make.top.mas_equalTo(_schoolLabel.mas_bottom).mas_offset(7);
            make.width.mas_equalTo(39.f);
            make.height.mas_equalTo(19.f);
        }];
        
        [_answerNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_answerNumberTipLabel.mas_right).mas_offset(8 * [UIView scale]);
            make.centerY.mas_equalTo(_answerNumberTipLabel.mas_centerY);
            make.width.mas_equalTo(45 * [UIView scale]);
        }];
        
        [_correctRateTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_answerNumberLabel.mas_right);
            make.centerY.mas_equalTo(_answerNumberTipLabel.mas_centerY);
            make.width.mas_equalTo(39.f);
            make.height.mas_equalTo(19.f);
        }];
        
        [_correctRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_correctRateTipLabel.mas_right).mas_offset(8 * [UIView scale]);
            make.centerY.mas_equalTo(_answerNumberTipLabel.mas_centerY);
            make.right.mas_equalTo(0);
        }];
        
        [_firstThreeRankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(64);
            make.top.mas_equalTo(2);
            make.right.mas_equalTo(-2);
        }];
    }
    return self;
}

- (void)setRankItem:(YXRankItem *)rankItem
{
    _rankItem = rankItem;
    self.rankNumberLabel.text = rankItem.rankNumber;
    if ([rankItem.rankNumber integerValue] <= 3) {
        self.rankNumberView.image = [UIImage imageNamed:@"1"];
        self.headerBGView.image = [UIImage imageNamed:@"前三名头像边框"];
        self.rankNumberLabel.edgeColor = [UIColor yx_colorWithHexString:@"007373"];
    } else {
        self.rankNumberView.image = [UIImage imageNamed:@"4"];
        self.headerBGView.image = [UIImage imageNamed:@"后七名头像边框"];
        self.rankNumberLabel.edgeColor = [UIColor yx_colorWithHexString:@"805500"];
    }
    [self.rankNumberLabel setNeedsDisplay];
    
    UIImage *placeholderImage = [UIImage imageNamed:@"默认头像"];
    if ([rankItem.portraitUrl yx_isHttpLink]) {
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:rankItem.portraitUrl] placeholderImage:placeholderImage];
    } else {
        self.headerView.image = placeholderImage;
    }
    self.nameLabel.text = rankItem.name;
    self.schoolLabel.text = rankItem.school;
    self.correctRateLabel.text = rankItem.correctRate;
    self.answerNumberLabel.text = rankItem.answeredNumber;
    self.firstThreeRankView.image = [self firstThreeRankImageWithRank:rankItem.rankNumber];
}

- (UIImage *)firstThreeRankImageWithRank:(NSString *)rank
{
    if ([rank isEqualToString:@"1"]) {
        return [UIImage imageNamed:@"冠军"];
    }else if ([rank isEqualToString:@"2"]){
        return [UIImage imageNamed:@"亚军"];
    }else if ([rank isEqualToString:@"3"]){
        return [UIImage imageNamed:@"季军"];
    }
    return nil;
}

@end
