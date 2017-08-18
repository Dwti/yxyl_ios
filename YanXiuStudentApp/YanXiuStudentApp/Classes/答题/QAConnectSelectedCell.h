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
@class QAConnectSelectedCell;

typedef void(^CellHeightChangeBlock)(CGFloat height);
typedef void(^DeleteOptionActionBlock)(QAConnectTwinOptionInfo *twinOption ,QAConnectSelectedCell *selectedCell);

@interface QAConnectSelectedCell : UITableViewCell
@property (nonatomic, strong, readonly) UIView *containerView;
@property (nonatomic, strong, readonly) UIButton *deleteButton;

@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

- (void)setCellHeightChangeBlock:(CellHeightChangeBlock)block;
- (void)setDeleteOptionActionBlock:(DeleteOptionActionBlock)block;
- (void)updateWithTwinOption:(QAConnectTwinOptionInfo *)twinOption;
+ (CGFloat)heightForTwinOption:(QAConnectTwinOptionInfo *)twinOption;

@end
