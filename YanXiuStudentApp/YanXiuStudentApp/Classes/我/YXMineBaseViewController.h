//
//  YXMineBaseViewController.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "YXMineTableViewCell.h"
#import "YXMineSelectCell.h"

@interface YXMineBaseViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly) UITableView *tableView;

- (BOOL)showLineAtIndexPath:(NSIndexPath *)indexPath;

@end
