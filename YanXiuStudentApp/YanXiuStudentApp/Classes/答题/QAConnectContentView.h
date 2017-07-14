//
//  QAConnectContentView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAConnectOptionInfo.h"

typedef void(^SelectedTwinOptionActionBlock)(QAConnectOptionInfo *leftOptionInfo,QAConnectOptionInfo *rightOptionInfo);

@interface QAConnectContentView : UIView
@property (nonatomic, strong) NSMutableArray<QAConnectOptionInfo *> *optionInfoArray;

- (void)updateWithLeftOptionArray:(NSMutableArray *)leftArray rightOPtionArray:(NSMutableArray *)rightArray;
- (void)setSelectedTwinOptionActionBlock:(SelectedTwinOptionActionBlock)block;

@end
