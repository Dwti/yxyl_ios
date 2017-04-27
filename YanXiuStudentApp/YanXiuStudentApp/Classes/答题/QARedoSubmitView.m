//
//  QARedoSubmitView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QARedoSubmitView.h"

@interface QARedoSubmitView()
@property (nonatomic, strong) QAQuestion *question;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) RACDisposable *dispose;
@end

@implementation QARedoSubmitView

- (void)dealloc {
    [self.dispose dispose];
}

- (instancetype)initWithQuestion:(QAQuestion *)question {
    if (self = [super initWithFrame:CGRectZero]) {
        self.question = question;
        [self setupUI];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.actionButton = [[UIButton alloc]init];
    [self.actionButton setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    [self.actionButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"黄按钮"] forState:UIControlStateNormal];
    [self.actionButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"黄按钮-按下"] forState:UIControlStateHighlighted];
    [self.actionButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.actionButton];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    self.dispose = [RACObserve(self.question, redoStatus) subscribeNext:^(id x) {
        STRONG_SELF
        NSNumber *num = x;
        QARedoStatus status = num.integerValue;
        if (status == QARedoStatus_Init) {
            [self.actionButton setTitle:@"提交" forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"按钮不可点击"] forState:UIControlStateNormal];
            self.actionButton.userInteractionEnabled = NO;
            self.actionButton.alpha = 0.4;
        }else if (status == QARedoStatus_CanSubmit) {
            [self.actionButton setTitle:@"提交" forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"黄按钮"] forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"黄按钮-按下"] forState:UIControlStateHighlighted];
            self.actionButton.userInteractionEnabled = YES;
            self.actionButton.alpha = 1;
        }else if (status == QARedoStatus_CanDelete) {
            [self.actionButton setTitle:@"删除本题" forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"黄按钮"] forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"黄按钮-按下"] forState:UIControlStateHighlighted];
            self.actionButton.userInteractionEnabled = YES;
            self.actionButton.alpha = 1;
        }else if (status == QARedoStatus_AlreadyDelete) {
            [self.actionButton setTitle:@"本题已被删除" forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"按钮不可点击"] forState:UIControlStateNormal];
            self.actionButton.userInteractionEnabled = NO;
            self.actionButton.alpha = 0.4;
        }
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
    }
}

- (void)showToast:(NSString *)text {
    [[UIApplication sharedApplication].keyWindow.rootViewController yx_showToast:text];
}

@end
