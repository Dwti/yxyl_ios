//
//  YXQAYesNoChooseCell_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXAutoGoNextDelegate.h"

@interface YXQAYesNoChooseCell_Pad : UITableViewCell
@property (nonatomic, strong) NSMutableArray *myAnswerArray;
@property (nonatomic, assign) id<YXAutoGoNextDelegate> delegate;

@property (nonatomic, strong) QAQuestion *item;

- (void)resetYesNoState;
- (void)updateWithMyAnswer:(NSArray *)myAnswerArray correctAnswer:(NSArray *)correctAnswerArray;
@end
