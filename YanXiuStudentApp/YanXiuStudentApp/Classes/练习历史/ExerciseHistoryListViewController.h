//
//  ExerciseHistoryListViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "PagedListViewControllerBase.h"

@class GetPracticeEditionRequestItem_subject;

@interface ExerciseHistoryListViewController : PagedListViewControllerBase
@property (nonatomic, strong) GetPracticeEditionRequestItem_subject *subject;
@property (nonatomic, assign) YXExerciseListSegment segment;
@end
