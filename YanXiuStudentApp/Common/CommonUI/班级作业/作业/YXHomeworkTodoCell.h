//
//  YXHomeworkTodoCell.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/21/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXHomeworkCellBase.h"
#import "YXHomework.h"

@interface YXHomeworkTodoCell : YXHomeworkCellBase
- (void)updateWithData:(YXHomework *)data;
@end
