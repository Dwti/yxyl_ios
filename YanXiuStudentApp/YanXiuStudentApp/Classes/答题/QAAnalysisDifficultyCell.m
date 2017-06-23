//
//  QAAnalysisDifficultyCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisDifficultyCell.h"
#import "YXStarRateView.h"

@interface QAAnalysisDifficultyCell()
@property (nonatomic, strong) YXStarRateView *rateView;
@end

@implementation QAAnalysisDifficultyCell

- (void)setupUI{
    [super setupUI];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.rateView = [[YXStarRateView alloc]initWithFrame:CGRectMake(0, 13, 135, 23)];
    [self.containerView addSubview:self.rateView];
}

- (void)setDifficulty:(NSString *)difficulty{
    _difficulty = difficulty;
    CGFloat rate = difficulty.floatValue/5;
    self.rateView.scorePercent = rate;
}

+ (CGFloat)height{
    return 82;
}

@end
