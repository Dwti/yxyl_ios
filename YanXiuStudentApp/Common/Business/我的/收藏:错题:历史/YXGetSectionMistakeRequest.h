//
//  YXGetSectionMistakeRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/15.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

// 获取章节错题数
@interface YXGetSectionMistakeRequest : YXGetRequest

@property (nonatomic, strong) NSString *stageId;    //学段Id
@property (nonatomic, strong) NSString *subjectId;  //学科Id
@property (nonatomic, strong) NSString *beditionId; //教材版本Id
@property (nonatomic, strong) NSString *volume;     //册Id

@end
