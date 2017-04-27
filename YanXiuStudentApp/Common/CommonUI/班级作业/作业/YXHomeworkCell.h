//
//  YXHomeworkCell.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/22/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXHomeworkCellBase.h"
#import "YXHomework.h"
#import "YXHomeworkMock.h"

@interface YXHomeworkCell : YXHomeworkCellBase
- (void)updateWithData:(YXHomeworkMock *)data;
@end
