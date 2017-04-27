//
//  YXMineBaseViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXBaseViewController_Pad.h"
#import "YXMineTableViewCell.h"
#import "YXMineSelectCell.h"

@interface YXMineBaseViewController_Pad : YXBaseViewController_Pad<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly) UITableView *tableView;

- (BOOL)showLineAtIndexPath:(NSIndexPath *)indexPath;

@end
