//
//  YXProblemItem.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXRecordBase.h"

@interface YXProblemItem : YXRecordBase

@property (nonatomic, copy) NSString *editionID;
@property (nonatomic, copy) NSString *gradeID;
@property (nonatomic, copy) NSString *subjectID;

/**
 *  试卷类型：paperType（0，练习，1，作业）
 */
@property (nonatomic, strong) NSNumber *paperType;
@property (nonatomic, copy) NSString *quesNum;
@property (nonatomic, copy) NSArray *questionID;

@end
