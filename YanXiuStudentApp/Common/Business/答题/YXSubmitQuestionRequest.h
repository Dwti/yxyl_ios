//
//  YXSubmitQuestionRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

typedef NS_ENUM(NSInteger, YXPType) {
    YXPTypeIntelligenceExercise, //智能练习
    YXPTypeGroupHomework,         //班级作业
    YXPTypeExerciseHistory,         //练习历史
    YXPTypeBCResourceExercise   //bc资源的练习
};

//extern NSString *const YXSubmitQuestionSuccessNotification;

@interface YXSubmitQuestionRequestItem : HttpBaseRequestItem

@end

@protocol YXAnswersItem_PaperDetail <NSObject>

@end

@interface YXAnswersItem_PaperDetail : JSONModel

@property (nonatomic, strong) NSArray<Optional> *answer; // 答案
@property (nonatomic, strong) NSString<Optional> *costtime;  // 总共花费时间
@property (nonatomic, strong) NSString<Optional> *ptid;   // 题目id
@property (nonatomic, strong) NSString<Optional> *status;    // 题目状态 0 回答正确， 1 回答错误， 3 未作答案 4 标示主观题 已作答
@property (nonatomic, strong) NSString<Optional> *uid;       // 用户id
@property (nonatomic, strong) NSString<Optional> *paperDetailId; // 答题明细id, 如果是第一次 填写默认 -1, 否则保持原样发送回来 （非常重要）
@property (nonatomic, strong) NSString<Optional> *qid; // 问题id
@property (nonatomic, strong) NSString<Optional> *qtype; // 0 标示客观题， 1标示主观题， 如果为空则表示 0 客观题
@property (nonatomic, strong) NSArray<YXAnswersItem_PaperDetail,Optional> *children;

@property (nonatomic, strong) NSString<Optional> *objectiveScore; // 口语得分 0-3

@end

@interface YXAnswersItem_PaperStatus : JSONModel

@property (nonatomic, strong) NSString<Optional> *begintime;   // 开始答题时间
@property (nonatomic, strong) NSString<Optional> *endtime;   // 答题结束时间
@property (nonatomic, strong) NSString<Optional> *costtime; // 花费时间
@property (nonatomic, strong) NSString<Optional> *ppid;     // 试卷id
@property (nonatomic, strong) NSString<Optional> *status;   // 题目状态  状态 0 未作答， 1 未完成， 2 已完成
@property (nonatomic, strong) NSString<Optional> *uid;      // 用户id
@property (nonatomic, strong) NSString<Optional> *tid;
@property (nonatomic, strong) NSString<Optional> *paperStatusId; // 对应答题历史 paperStatus 的id

@end

@interface YXAnswersItem : JSONModel

@property (nonatomic, strong) NSString<Optional> *chapterId; //章节id
@property (nonatomic, strong) NSArray<YXAnswersItem_PaperDetail, Optional> *paperDetails; // 每到题目的答案
@property (nonatomic, strong) YXAnswersItem_PaperStatus<Optional> *paperStatus; // 当前答题的属性
//@property (nonatomic, strong) NSString<Optional> *ppstatus; // 0 表示已完成， 1表示未完成
@property (nonatomic, strong) NSString<Optional> *ptype;    // 1 for 班级作业 0 for 智能练习 2 for 考点练习 10 for BC资源

@end

// 提交答题
@interface YXSubmitQuestionRequest : YXPostRequest

@property (nonatomic, strong) NSString *answers;
@property (nonatomic, strong) NSString *ppId;

@end
