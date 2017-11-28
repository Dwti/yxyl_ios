//
//  QAAnswerSheetViewController.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SelectedActionBlock)(QAQuestion *item);
typedef void(^BackActionBlock)(void);

@interface QAAnswerSheetViewController : BaseViewController

@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, assign) YXPType pType;
@property (nonatomic, assign) NSInteger totalQuestionCount;
@property (nonatomic, assign) NSInteger answeredQuestionCount;
@property (nonatomic, strong) YXQARequestParams *requestParams;
@property(nonatomic, copy) NSString *rmsPaperId;//仅用于BC资源
@property (nonatomic, strong) NSDate *beginDate;

- (void)setSelectedActionBlock:(SelectedActionBlock)block;
- (void)setBackActionBlock:(BackActionBlock)block;

@end
