//
//  QARedoSubmitView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QARedoSubmitView.h"

@interface QARedoSubmitView()
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) RACDisposable *dispose;
@end

@implementation QARedoSubmitView

- (void)dealloc {
    [self.dispose dispose];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.actionButton = [[UIButton alloc]init];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.actionButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    self.actionButton.layer.cornerRadius = 6;
    self.actionButton.clipsToBounds = YES;
    [self addSubview:self.actionButton];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)btnAction {
    if (self.question.redoStatus == QARedoStatus_CanSubmit) {
        self.question.redoStatus = QARedoStatus_CanDelete;
        if ([self.question answerState] == YXAnswerStateCorrect) {
            [self showToast:@"恭喜你，答对啦～"];
        }else {
            [self showToast:@"很遗憾，答错啦！"];
        }
    }else if (self.question.redoStatus == QARedoStatus_CanDelete) {
        self.question.redoStatus = QARedoStatus_AlreadyDelete;
    }else if (self.question.redoStatus == QARedoStatus_Init) {
        [self showToast:@"作答后才能提交哦～"];
    }else if (self.question.redoStatus == QARedoStatus_AlreadyDelete) {
        [self showToast:@"本题已被删除！"];
    }else if (self.question.redoStatus == QARedoStatus_ShowAnalysis) {
        self.question.redoStatus = QARedoStatus_CanDelete;
    }
}

- (void)showToast:(NSString *)text {
    [[UIApplication sharedApplication].keyWindow.rootViewController.view nyx_showToast:text];
}

- (void)setQuestion:(QAQuestion *)question {
    _question = question;
    [self.dispose dispose];
    WEAK_SELF
    self.dispose = [RACObserve(self.question, redoStatus) subscribeNext:^(id x) {
        STRONG_SELF
        NSNumber *num = x;
        QARedoStatus status = num.integerValue;
        if (status == QARedoStatus_Init) {
            [self.actionButton setTitle:@"提交" forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"cccccc"]] forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"cccccc"]] forState:UIControlStateHighlighted];
        }else if (status == QARedoStatus_CanSubmit) {
            [self.actionButton setTitle:@"提交" forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"69ad0a"]] forState:UIControlStateHighlighted];
        }else if (status == QARedoStatus_CanDelete) {
            [self.actionButton setTitle:@"删除本题" forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"69ad0a"]] forState:UIControlStateHighlighted];
        }else if (status == QARedoStatus_AlreadyDelete) {
            [self.actionButton setTitle:@"本题已被删除" forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"cccccc"]] forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"cccccc"]] forState:UIControlStateHighlighted];
        }else if (status == QARedoStatus_ShowAnalysis) {
            [self.actionButton setTitle:@"查看解析" forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"69ad0a"]] forState:UIControlStateHighlighted];
        }
    }];
}

@end
