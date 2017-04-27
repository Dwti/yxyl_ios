//
//  YXGenKnpointQBlockRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/11/2.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXIntelligenceQuestionListItem.h"

// 获得智能练习知识点题目
@interface YXGenKnpointQBlockRequest : YXGetRequest

@property (nonatomic, strong) NSString *stageId;   //学段id
@property (nonatomic, strong) NSString *subjectId; //学科id
@property (nonatomic, strong) NSString *questNum;  //题目数量
@property (nonatomic, strong) NSString *knpId1;    //一级知识点id
@property (nonatomic, strong) NSString *knpId2;    //二级知识点id
@property (nonatomic, strong) NSString *knpId3;    //三级知识点id
@property (nonatomic, strong) NSString *fromType;  //出题出处（0：知识点列表出题，1：从解析处出题， 2:考点掌握出题）

@end
