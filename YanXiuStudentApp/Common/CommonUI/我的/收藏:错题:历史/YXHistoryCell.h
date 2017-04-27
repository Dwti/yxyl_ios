//
//  YXHistoryCell.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/22/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXHomeworkCellBase.h"
#import "YXGetPracticeHistoryRequest.h"

@interface YXHistoryCell : YXHomeworkCellBase
- (void)updateWithData:(YXGetPracticeHistoryItem_Data *)data;

@end
