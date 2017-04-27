//
//  MistakeQuestionItemCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MistakeQuestionItemCell.h"

@interface MistakeQuestionItemCell()
@property (nonatomic, strong) UIButton *itemButton;
@end

@implementation MistakeQuestionItemCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.itemButton = [[UIButton alloc]init];
    [self.itemButton setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    self.itemButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.itemButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.itemButton];
    [self.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)btnAction {
    BLOCK_EXEC(self.clickBlock,self);
}

- (void)setItem:(QAQuestion *)item{
    _item = item;
    NSString *title = [NSString stringWithFormat:@"%@",@(item.position.firstLevelIndex+1)];
    [self.itemButton setTitle:title forState:UIControlStateNormal];
    YXQAAnswerState state = [item answerState];
    if (state == YXAnswerStateCorrect ||
        state == YXAnswerStateWrong ||
        state == YXAnswerStateAnswered) {
        [self.itemButton setBackgroundImage:[UIImage imageNamed:@"已答按钮"] forState:UIControlStateNormal];
    }else {
        [self.itemButton setBackgroundImage:[UIImage imageNamed:@"未答按钮"] forState:UIControlStateNormal];
    }
}
@end
