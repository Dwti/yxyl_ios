//
//  QAQuestionBaseView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAQuestionBaseView.h"

@interface QAQuestionBaseView()
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, assign) BOOL layoutComplete;
@property (nonatomic, strong) QAQuestion *oriData;
@end

@implementation QAQuestionBaseView

- (void)enterForeground{
    self.beginDate = [NSDate date];
}

- (void)leaveForeground{
    if (self.beginDate) {
        NSTimeInterval interval = [[NSDate date]timeIntervalSinceDate:self.beginDate];
        self.data.answerDuration += interval;
        self.beginDate = nil;        
    }
}

- (void)setData:(QAQuestion *)data {
    self.oriData = data;
    if (data.childQuestions.count == 1 && data.templateType != YXQATemplateClozeComplex) {
        QAQuestion *question = data.childQuestions.firstObject;
        if (question.templateType != YXQATemplateOral) {
            question.questionType = data.questionType;
        }
        _data = question;
        return;
    }
    _data = data;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.layoutComplete) {
        return;
    }
    [self setupUI];
    self.layoutComplete = YES;
}

- (void)setupUI{
    CGFloat titleHeight = self.isSubQuestionView? 0:43;
    self.titleView = [[QATitleView alloc]init];
    self.titleView.item = self.data;
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(titleHeight);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        DDLogDebug(@"%@", self.class);
    }
    return self;
}

@end
