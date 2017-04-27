//
//  YXLoginCell.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/21.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kYXLoginCellIdentifier;

@interface YXLoginCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL showLine;    //显示虚线
@property (nonatomic, assign) CGFloat interval; //间距，默认为2.f

@end
