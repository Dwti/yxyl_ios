//
//  YXSettingBaseViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXBaseViewController_Pad.h"
#import "YXMineTableViewCell.h"
#import "YXMineSelectCell.h"

@interface YXSettingBaseViewController_Pad : YXBaseViewController_Pad<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly) UITableView *tableView;

- (BOOL)showLineAtIndexPath:(NSIndexPath *)indexPath;

@end
