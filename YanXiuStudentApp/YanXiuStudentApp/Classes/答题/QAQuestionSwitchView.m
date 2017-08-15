//
//  QAQuestionSwitchView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/23.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAQuestionSwitchView.h"

@interface QAQuestionSwitchView()
@property (nonatomic, strong) UIButton *preButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *completeButton;
@end

@implementation QAQuestionSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.94];
    self.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -2.5);
    self.layer.shadowRadius = 2.5;
    self.layer.shadowOpacity = 0.02;
    
    self.preButton = [[UIButton alloc]init];
    [self.preButton setTitle:@"上一题" forState:UIControlStateNormal];
    [self.preButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [self.preButton setImage:[UIImage imageNamed:@"上一题箭头正常态"] forState:UIControlStateNormal];
    [self.preButton setImage:[UIImage imageNamed:@"上一题箭头点击态"] forState:UIControlStateHighlighted];
    self.preButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.preButton addTarget:self action:@selector(preAction) forControlEvents:UIControlEventTouchUpInside];
    self.preButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    self.preButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [self addSubview:self.preButton];
    [self.preButton sizeToFit];
    [self.preButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.preButton.width+10);
    }];
    
    self.nextButton = [[UIButton alloc]init];
    [self.nextButton setTitle:@"下一题" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [self.nextButton setImage:[UIImage imageNamed:@"下一题箭头正常态"] forState:UIControlStateNormal];
    [self.nextButton setImage:[UIImage imageNamed:@"下一题箭头点击态"] forState:UIControlStateHighlighted];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton.titleLabel sizeToFit];
    self.nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.nextButton.titleLabel.width+5, 0, -(self.nextButton.titleLabel.width+5));
    self.nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15-5, 0, 5+15);
    [self addSubview:self.nextButton];
    [self.nextButton sizeToFit];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.nextButton.width+10);
    }];
    
    self.completeButton = [[UIButton alloc]init];
    [self.completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.completeButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    self.completeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.completeButton addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.completeButton];
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(40);
    }];
}

- (void)preAction {
    BLOCK_EXEC(self.preBlock);
    self.preButton.userInteractionEnabled = NO;
}

- (void)nextAction {
    BLOCK_EXEC(self.nextBlock);
    self.nextButton.userInteractionEnabled = NO;
}

- (void)completeAction {
    BLOCK_EXEC(self.completeBlock);
}

- (void)updateWithTotal:(NSInteger)total question:(QAQuestion *)question childIndex:(NSInteger)index {
    self.preButton.userInteractionEnabled = YES;
    self.nextButton.userInteractionEnabled = YES;
    self.preButton.hidden = NO;
    self.nextButton.hidden = NO;
    if (question.childQuestions.count == 0) {
        if (question.position.firstLevelIndex == 0) {
            self.preButton.hidden = YES;
        }
        if (question.position.firstLevelIndex == total-1) {
            self.nextButton.hidden = YES;
        }
    }else {
        if (question.position.firstLevelIndex == 0 && index == 0) {
            self.preButton.hidden = YES;
        }
        if (question.position.firstLevelIndex == total-1 && question.childQuestions.count-1 == index) {
            self.nextButton.hidden = YES;
        }
    }
    if (!self.lastButtonHidden) {
        self.completeButton.hidden = !self.nextButton.hidden;
    }else {
        self.completeButton.hidden = YES;
    }
}

@end
