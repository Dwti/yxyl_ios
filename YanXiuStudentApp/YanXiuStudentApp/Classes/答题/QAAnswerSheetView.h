//
//  QAAnswerSheetView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SubmitActionBlock)(void);

@interface QAAnswerSheetView : UIView
@property (nonatomic, strong) QAPaperModel *model;
- (void)setSubmitActionBlock:(SubmitActionBlock)block;
@end
