//
//  QASingleQuestionAnswerBaseView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAQuestionBaseView.h"
#import "YXHtmlCellHeightDelegate.h"
#import "QAComplexHeaderFactory.h"
@interface QASingleQuestionAnswerBaseView : QAQuestionBaseView<UITableViewDataSource,
    UITableViewDelegate,
    YXHtmlCellHeightDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellHeightArray;
@property (nonatomic, strong) UITableViewCell<QAComplexHeaderCellDelegate> *headerCell;
- (NSMutableArray *)heightArrayForCell;
@end
