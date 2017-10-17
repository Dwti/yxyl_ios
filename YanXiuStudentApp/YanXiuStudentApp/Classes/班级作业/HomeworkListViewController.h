//
//  HomeworkListViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "PagedListViewControllerBase.h"
#import "YXHomeworkListGroupsRequest.h"

@interface HomeworkListViewController : PagedListViewControllerBase
- (instancetype)initWithData:(YXHomeworkListGroupsItem_Data *)data;
@property (nonatomic, strong) void (^emptyBlock)(void);
@end
