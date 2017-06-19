//
//  QAReportQuestionItemCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/21.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAReportQuestionItemCell.h"
#import "QAQuestionNumberButton.h"

@interface QAReportQuestionItemCell ()
@property (nonatomic, strong) QAQuestionNumberButton *itemButton;
@property (nonatomic, copy) ChoseActionBlock buttonActionBlock;
@end


@implementation QAReportQuestionItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.itemButton = [[QAQuestionNumberButton alloc]init];
    self.itemButton.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.itemButton.highlightedTextColor = [UIColor colorWithHexString:@"ffffff"];
    WEAK_SELF
    [self.itemButton setClickActionBlock:^{
        STRONG_SELF
        BLOCK_EXEC(self.buttonActionBlock,self.item);
    }];
    [self addSubview:self.itemButton];
    [self.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setItem:(QAQuestion *)item {
    _item = item;
    
    self.itemButton.title = item.position.indexDetailString;
    
    YXQAAnswerState state = [item answerState];
    YXQATemplateType type = item.templateType;
    if (type != YXQATemplateSubjective) {
        if (state == YXAnswerStateCorrect) {
            self.itemButton.imageName = @"答对题目-";
        }else{
            self.itemButton.imageName = @"答错题目-";
        }
    }else{
        if (state == YXAnswerStateCorrect) {
            self.itemButton.imageName = @"答对题目-";
        }else if (state == YXAnswerStateWrong){
            self.itemButton.imageName = @"答错题目-";
        }else if(state == YXAnswerStateHalfCorrect){
            self.itemButton.imageName = @"半对题-";
        }else{
            self.itemButton.imageName = @"未批改题目-";
        }
    }
}

- (void)setChoseActionBlock:(ChoseActionBlock)block {
    self.buttonActionBlock = block;
}
@end
