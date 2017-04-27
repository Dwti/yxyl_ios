//
//  QAComlexQuestionAnswerBaseView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAQuestionBaseView.h"
#import "QASlideView.h"
#import "YXNoFloatingHeaderFooterTableView.h"

@interface QAComlexQuestionAnswerBaseView : QAQuestionBaseView <
YXAutoGoNextDelegate,
QASlideViewDataSource,
QASlideViewDelegate
>

@property (nonatomic, strong) QASlideView *slideView;

@property (nonatomic, strong) UIView *middleContainerView;
@property (nonatomic, strong) UIView *downContainerView;
// subclass need to override this func to implement specific UI
- (UIView *)topContainerView;

@end
