//
//  QAConnectAnalysisContentCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellHeightChangeBlock)(CGFloat height);

@interface QAConnectAnalysisContentCell : UITableViewCell
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, strong) NSMutableArray *groupArray;
@property (nonatomic, assign) BOOL showAnalysisAnswers;
//@property (nonatomic, weak) id<YXConnectContentCellDelegate> redoStatusDelegate;

+ (CGFloat)heightForItem:(QAQuestion *)item;
- (void)setCellHeightChangeBlock:(CellHeightChangeBlock)block;

@end
