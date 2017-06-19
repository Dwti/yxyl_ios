//
//  QAAnswerSheetViewController.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SelectedActionBlock)(QAQuestion *item);

@interface QAAnswerSheetViewController : BaseViewController

@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, assign) BOOL allHasWrote;
@property (nonatomic, strong) YXQARequestParams *requestParams;
- (void)setSelectedActionBlock:(SelectedActionBlock)block;
@end
