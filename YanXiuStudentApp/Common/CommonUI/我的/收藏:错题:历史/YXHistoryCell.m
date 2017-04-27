//
//  YXHistoryCell.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/22/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXHistoryCell.h"

@implementation YXHistoryCell

- (void)updateWithData:(YXGetPracticeHistoryItem_Data *)data {
    for (UIView *v in self.bottomLeftContainerView.subviews) {
        [v removeFromSuperview];
    }

    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self.bottomLeftContainerView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentLeft;
    label.layer.cornerRadius = 4;
    label.clipsToBounds = YES;
    label.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    label.layer.shadowOffset = CGSizeMake(0, 1);
    label.layer.shadowOpacity = 1;
    label.layer.shadowRadius = 0;
    [self.bottomLeftContainerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImageView.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(0);
        make.right.mas_lessThanOrEqualTo(-5);
    }];
    
    self.nameLabel.text = data.name;
    self.numberLabel.text = data.questionNum;
    if ([data isFinished]) {
        iconImageView.image = [UIImage imageNamed:@"恭喜你，全部完成^ ^"];
        label.textColor = [UIColor colorWithHexString:@"805500"];
        NSString *correctNum = data.correctNum;
        NSString *str = [NSString stringWithFormat:@"答对%@题", correctNum];
        NSRange numberRange = [str rangeOfString:correctNum];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:str];
        [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:numberRange];
        label.attributedText = attrString;
    } else {
        iconImageView.image = [UIImage imageNamed:@"未完成"];
        label.textColor = [UIColor colorWithHexString:@"007373"];
        label.text = @"未完成";
    }
    
    self.timeLabel.text = data.buildTime;
}

@end
