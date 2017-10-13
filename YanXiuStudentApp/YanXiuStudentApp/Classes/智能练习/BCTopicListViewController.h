//
//  BCTopicListViewController.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "PagedListViewControllerBase.h"
@class GetTopicTreeRequestItem_theme;

@interface BCTopicListViewController : PagedListViewControllerBase
- (instancetype)initWithTopicTheme:(GetTopicTreeRequestItem_theme *)topicTheme type:(NSString *)type;
@end
