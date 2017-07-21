//
//  ExerciseHistorySubjectCell.h
//  YanXiuStudentApp
//
//  Created by LiuWenXing on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXGetPracticeEditionRequest.h"

@interface ExerciseHistorySubjectCell : UITableViewCell

@property (nonatomic, strong) GetPracticeEditionRequestItem_subject *subject;
@property (nonatomic, assign) BOOL isLast;

@end
