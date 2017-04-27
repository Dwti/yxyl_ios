//
//  YXGetSectionQBlockRequest.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/7/21.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXIntelligenceQuestionListItem.h"

// 获得智能练习章节题目
@interface YXGetSectionQBlockRequest : YXGetRequest

@property (nonatomic, strong) NSString *stageId;   //学段id
@property (nonatomic, strong) NSString *subjectId; //学科id
@property (nonatomic, strong) NSString *editionId; //教材版本
@property (nonatomic, strong) NSString *volumeId;  //册id
@property (nonatomic, strong) NSString *chapterId; //章id
@property (nonatomic, strong) NSString *sectionId; //节id
@property (nonatomic, strong) NSString *questNum;  //题目数量
@property (nonatomic, strong) NSString *cellId;    //小节id
@property (nonatomic, strong) NSString *type_id;
@end
