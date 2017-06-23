//
//  QAAnalysisScoreCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisScoreCell.h"

static const CGFloat kAnswerScoreCellHeight = 120.0f;

@interface QAAnalysisScoreCell()
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *describeLabel;

@end


@implementation QAAnalysisScoreCell

- (void)setupUI{
    [super setupUI];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.font = [UIFont fontWithName:YXFontMetro_Bold size:70.0f];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"336600"];
    
    self.describeLabel = [[UILabel alloc]init];
    self.describeLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    self.describeLabel.textColor = [UIColor colorWithHexString:@"336600"];
    self.describeLabel.text = @"分";
    
    [self.containerView addSubview:self.scoreLabel];
    [self.containerView addSubview:self.describeLabel];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-9.0f);
    }];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreLabel.mas_right).offset(2.0f);
        make.bottom.equalTo(self.scoreLabel.mas_bottom).offset(-14.0f);
    }];
}

- (void)updateUI {
    if (self.isMarked) {
        self.describeLabel.hidden = NO;
        self.scoreLabel.text = [NSString stringWithFormat:@"%@",@(self.score)];
    } else {
        self.describeLabel.hidden = YES;
        NSString *str = @"老师未批改";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                       initWithString:str];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"69ad0a"]} range:NSMakeRange(0, [str length])];
        self.scoreLabel.attributedText = attributedString;
        [self.scoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-15.0f);
        }];
    }
    //    self.score = 5;
    //    self.scoreLabel.text = [NSString stringWithFormat:@"%@",@(self.score)];
}

+ (CGFloat)height {
    return kAnswerScoreCellHeight * kPhoneWidthRatio;
}
@end
