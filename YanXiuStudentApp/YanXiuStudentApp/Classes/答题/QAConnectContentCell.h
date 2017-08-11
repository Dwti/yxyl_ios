//
//  QAConnectContentCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QAConnectOptionInfo;

typedef void(^HeightChangeBlock)(CGFloat height);

@interface QAConnectContentCell : UITableViewCell
@property (nonatomic, strong) QAConnectOptionInfo *optionInfo;

@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

- (void)setHeightChangeBlock:(HeightChangeBlock)block;

- (CGSize)defaultSize;
@end
