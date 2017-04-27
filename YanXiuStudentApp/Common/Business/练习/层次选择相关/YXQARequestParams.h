//
//  YXQARequestParams.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXExerciseListParams.h"

@interface YXQARequestParams : YXExerciseListParams
@property (nonatomic, strong) NSString *chapterId; //章id
@property (nonatomic, strong) NSString *sectionId; //节id
@property (nonatomic, strong) NSString *cellId;    //小节id
@property (nonatomic, strong) NSString *questNum;  //题目数量

@property (nonatomic, strong) NSString *fromType;  //出题出处（0：知识点列表出题，1：从解析处出题, 2:考点掌握出题）
@end
