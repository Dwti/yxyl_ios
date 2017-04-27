//
//  YXQASheetView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQASheetView_Pad.h"

static const NSInteger kTagbase = 222;

@interface YXQASheetView_Pad()
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *itemContainerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *stateArray;
@property (nonatomic, strong) NSArray *questionArray;
@end

@implementation YXQASheetView_Pad

#pragma mark- Get
- (NSString *)wrote
{
    int total = 0;
    for (NSNumber *state in self.stateArray) {
        total += state.intValue;
    }
    return [NSString stringWithFormat:@"%d", total];
}

#pragma mark-
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.maskView = [[UIView alloc]initWithFrame:self.bounds];
    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    [self addSubview:self.maskView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.maskView addGestureRecognizer:tap];
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(180, self.bounds.size.height-47-90, self.bounds.size.width-360, 47+90)];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffe580"];
    [self addSubview:self.contentView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.textColor = [UIColor colorWithHexString:@"805500"];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(46);
    }];
    
    YXSmartDashLineView *dash = [[YXSmartDashLineView alloc]init];
    dash.lineColor = [UIColor colorWithHexString:@"e6bb47"];
    dash.dashWidth = 4;
    dash.gapWidth = 3;
    [self.contentView addSubview:dash];
    [dash mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(46);
    }];
    
    self.itemContainerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 47, self.contentView.bounds.size.width, 0)];
    self.itemContainerView.backgroundColor = [UIColor colorWithHexString:@"fff0b2"];
    [self.contentView addSubview:self.itemContainerView];
    
    YXSmartDashLineView *dash2 = [[YXSmartDashLineView alloc]init];
    dash2.lineColor = [UIColor colorWithHexString:@"e6bb47"];
    dash2.dashWidth = 4;
    dash2.gapWidth = 3;
    [self.contentView addSubview:dash2];
    [dash2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(-89);
    }];
    
    UIButton *submitButton = [[UIButton alloc]init];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"提交"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"提交-按下"] forState:UIControlStateHighlighted];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [submitButton.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"ffff99"]];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(175, 50));
    }];
}

- (void)setModel:(QAPaperModel *)model{
    _model = model;
    self.titleLabel.text = model.paperTitle;
    self.questionArray = [model allQuestions];
    for (UIView *v in self.itemContainerView.subviews) {
        [v removeFromSuperview];
    }
    self.stateArray = [NSMutableArray array];
    CGFloat yGap = 25.f;
    CGFloat xGap = (self.contentView.bounds.size.width-45*10)/11;
    [self.questionArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAQuestion *item = (QAQuestion *)obj;
        UIButton *b = [[UIButton alloc]init];
        b.frame = CGRectMake(xGap+(45+xGap)*(idx%10), yGap+(45+yGap)*(idx/10), 45, 45);
        [b setTitle:item.position.indexDetailString forState:UIControlStateNormal];
        [b setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        b.titleLabel.adjustsFontSizeToFitWidth = YES;
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
    self.itemContainerView.contentSize = CGSizeMake(self.itemContainerView.frame.size.width, (self.questionArray.count+9)/10*(45+yGap)+25);
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
}

- (void)submit{
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sheetViewDidSubmit)]) {
        [self.delegate sheetViewDidSubmit];
    }
}

- (void)btnAction:(UIButton *)sender{
    [self hide];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:)]) {
//        [self.delegate sheetViewDidSelectIndex:sender.tag-kTagbase];
//    }
}

- (void)showInView:(UIView *)view{
    [view addSubview:self];
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.bounds.size.height, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.bounds.size.height-self.contentView.frame.size.height, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.bounds.size.height, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)allHasAnswer {
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
