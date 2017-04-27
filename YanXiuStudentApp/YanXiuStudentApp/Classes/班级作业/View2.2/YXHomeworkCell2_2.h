//
//  YXHomeworkCell2.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/4/6.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXHomework.h"
#import "YXHomeworkMock.h"
@interface YXHomeworkCell2_2 : UITableViewCell

@property (nonatomic, copy) NSString *answerNum;
@property (nonatomic, copy) NSString *status;

- (void)updateWithData:(YXHomeworkMock *)data;

@property (nonatomic, copy) void (^clickBlock)();

@end
