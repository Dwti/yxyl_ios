//
//  YXQAClassifyView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/5.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASingleQuestionAnswerBaseView.h"

@interface QAClassifyQuestionView : QASingleQuestionAnswerBaseView <
UITableViewDelegate,
UITableViewDataSource,
YXHtmlCellHeightDelegate
>

@property (nonatomic, assign) BOOL isAnalysis;

@end


