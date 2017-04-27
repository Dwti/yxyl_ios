//
//  QAQuestionViewContainer.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QAQuestionBaseView.h"

@interface QAQuestionViewContainer : NSObject
- (QAQuestionBaseView *)questionAnswerView;
- (QAQuestionBaseView *)questionAnalysisView;
- (QAQuestionBaseView *)questionRedoView;
@end
