//
//  QABaseViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "QAQuestionSwitchView.h"

@interface QABaseViewController : BaseViewController<QASlideViewDataSource,QASlideViewDelegate,QAQuestionViewSlideDelegate>
@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, strong) QASlideView *slideView;
@property (nonatomic, strong) QAQuestionSwitchView *switchView;

- (void)setupUI;
- (void)completeButtonAction;
@end
