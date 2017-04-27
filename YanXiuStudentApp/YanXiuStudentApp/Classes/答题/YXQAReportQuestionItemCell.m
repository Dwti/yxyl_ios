//
//  YXQAReportQuestionItemCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/5.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAReportQuestionItemCell.h"

@interface YXQAReportQuestionItemCell()
@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, strong) UIImageView *markImageView;
@end

@implementation YXQAReportQuestionItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.centerButton = [[UIButton alloc]init];
    [self.centerButton setBackgroundImage:[UIImage imageNamed:@"选择器背景"] forState:UIControlStateNormal];
    [self.centerButton setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    self.centerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.centerButton.userInteractionEnabled = NO;
    [self.contentView addSubview:self.centerButton];
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    self.markImageView = [[UIImageView alloc]init];
    [self.centerButton addSubview:self.markImageView];
    [self.markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.centerButton.mas_right).mas_offset(3);
        make.bottom.mas_equalTo(self.centerButton.mas_bottom).mas_offset(7);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)setItem:(QAQuestion *)item{
    _item = item;
    [self.centerButton setTitle:item.position.indexDetailString forState:UIControlStateNormal];
    YXQAAnswerState state = [item answerState];
    YXQATemplateType type = item.templateType;
    if (type != YXQATemplateSubjective) {
        if (state == YXAnswerStateCorrect) {
            self.markImageView.image = [UIImage imageNamed:@"对勾"];
        }else{
            self.markImageView.image = [UIImage imageNamed:@"叉子"];
        }
    }else{
        if (state == YXAnswerStateCorrect) {
            self.markImageView.image = [UIImage imageNamed:@"对勾"];
        }else if (state == YXAnswerStateWrong){
            self.markImageView.image = [UIImage imageNamed:@"叉子"];
        }else if(state == YXAnswerStateHalfCorrect){
            self.markImageView.image = [UIImage imageNamed:@"半对"];
        }else{
            self.markImageView.image = nil;
        }
    }
}

@end
