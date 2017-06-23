//
//  QAYesNoOptionCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAChooseOptionCell.h"
@interface QAYesNoOptionCell : UITableViewCell

@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, assign) BOOL choosed;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isAnalysis;
@property (nonatomic, assign) OptionCellMarkType markType;

@end
