//
//  QAConnectSelectedCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAConnectItemView.h"
@class QAConnectTwinOptionInfo;

typedef void(^CellHeightChangeBlock)(CGFloat height);
typedef void(^DeleteOptionActionBlock)(QAConnectTwinOptionInfo *twinOption);

@interface QAConnectSelectedCell : UITableViewCell
@property (nonatomic, strong) QAConnectItemView *leftView;
@property (nonatomic, strong) QAConnectItemView *rightView;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

- (void)setCellHeightChangeBlock:(CellHeightChangeBlock)block;
- (void)setDeleteOptionActionBlock:(DeleteOptionActionBlock)block;
- (void)updateWithTwinOption:(QAConnectTwinOptionInfo *)twinOption;
+ (CGFloat)heightForTwinOption:(QAConnectTwinOptionInfo *)twinOption;

@end
