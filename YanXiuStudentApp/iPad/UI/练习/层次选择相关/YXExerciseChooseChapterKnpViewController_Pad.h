//
//  YXExerciseChooseChapterKnpViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/10/27.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "YXExerciseListManager.h"
#import "YXExerciseListViewDelegate.h"
#import "YXBaseViewController_Pad.h"

@interface YXExerciseChooseChapterKnpViewController_Pad : YXBaseViewController_Pad<YXExerciseListViewDelegate>
@property (nonatomic, assign) CGFloat leftRightGapForTreeView;

@property (nonatomic, strong) GetSubjectRequestItem_subject *subject;
@property (nonatomic, weak) id<YXExerciseListViewDelegate> delegate;

// 请求练习的基本参数
- (YXExerciseListParams *)listParams;

// 删除操作后重新请求数据
- (void)reloadDataAfterDelete;

@end
