//
//  HomeworkSubjectCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXHomeworkListGroupsRequest.h"

@interface HomeworkSubjectCell : UITableViewCell
@property (nonatomic, strong) YXHomeworkListGroupsItem_Data *data;
@property (nonatomic, assign) BOOL isLast;
@end
