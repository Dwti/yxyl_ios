//
//  QAClassifyRedoView.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/18/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "QASingleQuestionRedoBaseView.h"

@interface QAClassifyRedoView : QASingleQuestionRedoBaseView <
UITableViewDelegate,
UITableViewDataSource,
YXHtmlCellHeightDelegate
>

@property (nonatomic, assign) BOOL isAnalysis;

@end
