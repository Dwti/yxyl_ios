//
//  ExerciseKnpTreeCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeBaseCell.h"
#import "GetKnpListRequest.h"
@class ExerciseKnpTreeCell;

@interface ExerciseKnpTreeCell : TreeBaseCell
@property (nonatomic, strong) GetKnpListRequestItem_knp *knp;
- (void)setTreeExpandBlock:(void(^)(ExerciseKnpTreeCell *cell))block;
- (void)setTreeClickBlock:(void(^)(ExerciseKnpTreeCell *cell))block;
@property (nonatomic, assign) BOOL isFirst;

@end
