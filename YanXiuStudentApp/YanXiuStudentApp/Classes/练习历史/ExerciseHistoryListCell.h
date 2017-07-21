//
//  ExerciseHistoryListCell.h
//  YanXiuStudentApp
//
//  Created by LiuWenXing on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXGetPracticeHistoryRequest.h"

@interface ExerciseHistoryListCell : UITableViewCell

@property (nonatomic, strong) YXGetPracticeHistoryItem_Data *data;

@end
