//
//  QAClozeContainerView.h
//  YanXiuStudentApp
//
//  Created by FanYu on 10/25/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAClozeQuestionCell.h"


@interface QAClozeContainerView : UIView

@property (nonatomic, assign) BOOL isAnalysis;
@property (nonatomic, strong) QAClozeQuestionCell *clozeCell;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, weak) id<QAClozeQuestionCellDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;

- (instancetype)initWithData:(QAQuestion *)data; //designated init

@end
