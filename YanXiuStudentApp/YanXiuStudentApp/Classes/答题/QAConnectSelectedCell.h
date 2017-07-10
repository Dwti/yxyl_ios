//
//  QAConnectSelectedCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAConnectContentCell.h"

@interface QAConnectSelectedCell : UITableViewCell
@property (nonatomic, strong) QAConnectContentCell *leftView;
@property (nonatomic, strong) QAConnectContentCell *rightView;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

//- (void)updateWithLeftContent:(NSString *)left rightContent:(NSString *)right;
//+ (CGFloat)heightForLeftContent:(NSString *)left rightContent:(NSString *)right;

@end
