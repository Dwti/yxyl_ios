//
//  YXQASheetView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/10.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXQASheetView.h"
#import "YXQADashLineView.h"

static const NSInteger kTagbase = 222;

@interface YXQASheetView()
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *itemContainerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *stateArray;
@property (nonatomic, strong) NSArray *questionArray;
@end

@implementation YXQASheetView

- (NSString *)wrote
{
    int total = 0;
    for (NSNumber *state in self.stateArray) {
        total += state.intValue;
    }
    return [NSString stringWithFormat:@"%d", total];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.maskView = [[UIView alloc]initWithFrame:self.bounds];
    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    [self addSubview:self.maskView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.maskView addGestureRecognizer:tap];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-302, self.bounds.size.width, 302)];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffe580"];
    [self addSubview:self.contentView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.textColor = [UIColor colorWithHexString:@"805500"];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(46);
    }];
    
    YXQADashLineView *dash = [[YXQADashLineView alloc]init];
    dash.color = [UIColor colorWithHexString:@"e6bb47"];
    [self.contentView addSubview:dash];
    [dash mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(46);
    }];
    
    YXQADashLineView *dash2 = [[YXQADashLineView alloc]init];
    dash2.color = [UIColor colorWithHexString:@"e6bb47"];
    [self.contentView addSubview:dash2];
    [dash2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(-89);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"取消icon"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"取消icon-按下"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.itemContainerView = [[UIScrollView alloc] init];
    self.itemContainerView.backgroundColor = [UIColor colorWithHexString:@"fff0b2"];
    [self.contentView addSubview:self.itemContainerView];
    [self.itemContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dash.mas_bottom);
        make.bottom.equalTo(dash2.mas_top);
        make.left.right.mas_equalTo(0);
    }];
    
    UIButton *submitButton = [[UIButton alloc]init];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"提交"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"提交-按下"] forState:UIControlStateHighlighted];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    submitButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    submitButton.titleLabel.layer.shadowRadius = 0;
    submitButton.titleLabel.layer.shadowOpacity = 1;
    submitButton.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(175, 50));
    }];
}

- (void)setModel:(QAPaperModel *)model{
    [self setupSheetViewHeightWithModel:model];
    
    _model = model;
    self.titleLabel.text = model.paperTitle;
    self.questionArray = [model allQuestions];
    for (UIView *v in self.itemContainerView.subviews) {
        [v removeFromSuperview];
    }
    self.stateArray = [NSMutableArray array];
    CGFloat yGap = 25.f;
    CGFloat xGap = (self.bounds.size.width-45*5)/6;
    [self.questionArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAQuestion *item = (QAQuestion *)obj;
        UIButton *b = [[UIButton alloc]init];
        b.frame = CGRectMake(xGap+(45+xGap)*(idx%5), yGap+(45+yGap)*(idx/5), 45, 45);
        [b setTitle:item.position.indexDetailString forState:UIControlStateNormal];
        [b setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:15];
        BOOL hasAnswer = [self _bHasAnswer:item];
        [self.stateArray addObject:@(hasAnswer)];
        if (hasAnswer) {
            [b setBackgroundImage:[UIImage imageNamed:@"已答按钮"] forState:UIControlStateNormal];
        }else{
            [b setBackgroundImage:[UIImage imageNamed:@"未答按钮"] forState:UIControlStateNormal];
        }
        b.tag = kTagbase + idx;
        [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemContainerView addSubview:b];
    }];
    self.itemContainerView.contentSize = CGSizeMake(self.itemContainerView.frame.size.width, (self.questionArray.count+4)/5*(45+yGap)+25);
}

- (void)setupSheetViewHeightWithModel:(QAPaperModel *)model {
    NSInteger numOfQuestions = [model allQuestions].count;
    NSInteger numOfColumns;
    if (numOfQuestions <= 10) {
        numOfColumns = 2;
    } else {
        numOfColumns = ceil((CGFloat)numOfQuestions / 5.0);
    }
    
    CGFloat height = 25 + numOfColumns * (45 + 25) + 137;
    CGFloat currentHeight = MIN(height, self.bounds.size.height - 25);
    
    self.contentView.frame = CGRectMake(0, self.bounds.size.height - currentHeight, self.bounds.size.width, currentHeight);
}

- (BOOL)_bHasAnswer:(QAQuestion *)data {
    YXQAAnswerState state = [data answerState];
    if (state == YXAnswerStateCorrect ||
        state == YXAnswerStateWrong ||
        state == YXAnswerStateAnswered) {
        return YES;
    }
    return NO;
}

- (void)tapAction{
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sheetViewDidCancel)]) {
        [self.delegate sheetViewDidCancel];
    }
}

- (void)submit{
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sheetViewDidSubmit)]) {
        [self.delegate sheetViewDidSubmit];
    }
}

- (void)cancelButtonTapped {
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sheetViewDidCancel)]) {
        [self.delegate sheetViewDidCancel];
    }
}

- (void)btnAction:(UIButton *)sender{
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sheetViewDidSelectItem:)]) {
        [self.delegate sheetViewDidSelectItem:self.questionArray[sender.tag-kTagbase]];
    }
}

- (void)showInView:(UIView *)view{
    [view addSubview:self];
    self.contentView.frame = CGRectMake(0, self.bounds.size.height, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, self.bounds.size.height-self.contentView.frame.size.height, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, self.bounds.size.height, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)bAllHasAnswer {
    BOOL bAll = YES;
    for (NSNumber *state in self.stateArray) {
        if (![state boolValue]) {
            bAll = NO;
            break;
        }
    }
    return bAll;
}
@end
