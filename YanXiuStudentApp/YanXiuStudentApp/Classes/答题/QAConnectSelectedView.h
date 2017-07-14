//
//  QAConnectSelectedView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAConnectOptionInfo.h"
@class QAConnectTwinOptionInfo;

typedef void(^FoldActionBlock)(void);
typedef void(^DeleteActionBlock)(QAConnectTwinOptionInfo *twinOption);
typedef void(^DeleteAllActionBlock)(NSMutableArray<QAConnectTwinOptionInfo *> *optionInfoArray);

@interface QAConnectSelectedView : UIView
@property (nonatomic, strong) NSMutableArray<QAConnectTwinOptionInfo *> *optionInfoArray;
@property (nonatomic, assign) BOOL isFold;

- (void)reloadData;
- (void)setFoldActionBlock:(FoldActionBlock)block;
- (void)setDeleteActionBlock:(DeleteActionBlock)block;
- (void)setDeleteAllActionBlock:(DeleteAllActionBlock)block;

@end
