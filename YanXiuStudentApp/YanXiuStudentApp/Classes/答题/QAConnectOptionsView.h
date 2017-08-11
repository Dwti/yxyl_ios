//
//  QAConnectOptionsView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAConnectOptionInfo.h"

typedef void(^SelectedOptionCellActionBlock)(QAConnectOptionInfo *optionInfo);


@interface QAConnectOptionsView : UIView
@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<QAConnectOptionInfo *> *optionInfoArray;

- (void)setSelectedOptionCellActionBlock:(SelectedOptionCellActionBlock)block;
- (void)reloadData;

@end
