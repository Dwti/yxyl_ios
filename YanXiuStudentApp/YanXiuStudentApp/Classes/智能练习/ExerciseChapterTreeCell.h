//
//  ExerciseChapterTreeCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetChapterListRequest.h"
#import "TreeBaseCell.h"

@class ExerciseChapterTreeCell;

typedef void(^ExpandBlock) (ExerciseChapterTreeCell *cell);
typedef void(^ClickBlock) (ExerciseChapterTreeCell *cell);

@interface ExerciseChapterTreeCell : TreeBaseCell
@property (nonatomic, strong) GetChapterListRequestItem_chapter *chapter;

- (void)setTreeExpandBlock:(ExpandBlock)block;
- (void)setTreeClickBlock:(ClickBlock)block;
@end
