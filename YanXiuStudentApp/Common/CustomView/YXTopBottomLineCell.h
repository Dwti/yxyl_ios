//
//  YXTopBottomLineCell.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/8/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXTopBottomLineCell : UITableViewCell
@property (nonatomic, strong) UIColor *lineColor;

// 只有左右起作用，left/right有一个为负数，则不显示
@property (nonatomic, assign) UIEdgeInsets topInsets;
@property (nonatomic, assign) UIEdgeInsets bottomInsets;
@end
