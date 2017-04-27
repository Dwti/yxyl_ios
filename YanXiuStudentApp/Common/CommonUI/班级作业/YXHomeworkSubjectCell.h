//
//  YXHomeworkSubjectCell.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/21/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXHomeworkGroupMock.h"
@interface YXHomeworkSubjectCell : UITableViewCell
@property (nonatomic, copy) void (^clickBlock)();
@property (nonatomic, assign) CGFloat interval;

- (void)updateWithData:(YXHomeworkGroupMock *)data;

@end
