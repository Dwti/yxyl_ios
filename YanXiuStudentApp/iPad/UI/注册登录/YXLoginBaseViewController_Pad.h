//
//  YXLoginBaseViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/26.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXBaseViewController_Pad.h"
#import "YXLoginCell.h"

extern CGFloat const kYXLoginCellWidth;

@interface YXLoginBaseViewController_Pad : YXBaseViewController_Pad<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly) UITableView *tableView;

- (BOOL)showLineAtIndexPath:(NSIndexPath *)indexPath;

// 子类实现
- (UIView *)viewForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
