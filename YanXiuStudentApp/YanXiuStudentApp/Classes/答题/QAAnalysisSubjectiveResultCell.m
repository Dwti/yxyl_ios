//
//  QAAnalysisSubjectiveResultCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/11.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisSubjectiveResultCell.h"

@interface QAAnalysisSubjectiveResultCell()
@property (nonatomic, strong) UILabel *resultLabel;
@end

@implementation QAAnalysisSubjectiveResultCell

- (void)setupUI{
    [super setupUI];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.resultLabel = [[UILabel alloc]init];
    self.resultLabel.font = [UIFont boldSystemFontOfSize:27.0f];
    self.resultLabel.textColor = [UIColor whiteColor];
    
    [self.containerView addSubview:self.resultLabel];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
}


- (void)updateUI {
    if (self.isMarked) {
        if (self.isCorrect) {
            self.resultLabel.text = @"回答正确";;
        } else {
            self.resultLabel.text = @"回答错误";
        }
    } else {
        NSString *str = @"老师未批改";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                       initWithString:str];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"69ad0a"]} range:NSMakeRange(0, [str length])];
        self.resultLabel.attributedText = attributedString;
        [self.resultLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-15.0f);
        }];
    }
}

+ (CGFloat)height {
    return 88.0f;
}


@end
