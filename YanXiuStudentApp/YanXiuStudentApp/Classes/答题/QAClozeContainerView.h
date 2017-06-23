//
//  QAClozeContainerView.h
//  YanXiuStudentApp
//
//  Created by FanYu on 10/25/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAClozeStemCell.h"

@interface QAClozeContainerView : UIView
@property (nonatomic, strong) QAClozeStemCell *clozeCell;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, weak) id<QAClozeQuestionCellDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isAnalysis;

- (instancetype)initWithData:(QAQuestion *)data; //designated init

- (void)scrollCurrentBlankToVisible;

@end
