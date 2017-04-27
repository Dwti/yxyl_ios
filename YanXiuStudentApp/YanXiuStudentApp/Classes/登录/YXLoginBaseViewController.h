//
//  YXLoginBaseViewController.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/3.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "YXLoginCell.h"

@interface YXLoginBaseViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly) UITableView *tableView;

- (BOOL)showLineAtIndexPath:(NSIndexPath *)indexPath;

// 子类实现
- (UIView *)viewForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
