//
//  QASingleQuestionRedoBaseView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QASingleQuestionAnswerBaseView.h"

@interface QASingleQuestionRedoBaseView : QASingleQuestionAnswerBaseView
@property (nonatomic, strong) QAAnalysisBackGroundView *analysisBGView;

- (void)refreshForRedoStatusChange;

@end
