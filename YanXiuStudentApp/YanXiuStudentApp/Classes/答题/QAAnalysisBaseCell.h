//
//  QAAnalysisBaseCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQAAnalysisItem.h"

@interface QAAnalysisBaseCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL isShowLine;
@property (nonatomic, strong) YXQAAnalysisItem *item;

- (void)setupUI;
@end
