//
//  QAConnectContentView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAConnectOptionInfo.h"
@class QAConnectOptionsView;

typedef void(^SelectedTwinOptionActionBlock)(QAConnectOptionInfo *leftOptionInfo,QAConnectOptionInfo *rightOptionInfo);

@interface QAConnectContentView : UIView
@property (nonatomic, strong, readonly) QAConnectOptionsView *leftView;
@property (nonatomic, strong, readonly) QAConnectOptionsView *rightView;
@property (nonatomic, strong) NSMutableArray<QAConnectOptionInfo *> *optionInfoArray;

- (void)updateWithLeftOptionArray:(NSMutableArray *)leftArray rightOPtionArray:(NSMutableArray *)rightArray;
- (void)setSelectedTwinOptionActionBlock:(SelectedTwinOptionActionBlock)block;

@end
