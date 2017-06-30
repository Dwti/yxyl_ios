//
//  YXQuestionBlock.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/13.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "JSONModel.h"
#import "YXQuestion.h"

//@interface YXIntelligenceQuestion_PaperTest_Extend_Data : JSONModel
//
//@property (nonatomic, copy) NSString<Optional> *globalStatis;
//@property (nonatomic, copy) NSString<Optional> *answerCompare;
//
//@end
//
//@interface YXIntelligenceQuestion_PaperTest_Extend : JSONModel
//
//@property (nonatomic, copy) YXIntelligenceQuestion_PaperTest_Extend_Data<Optional> *data;
//
//@end
//
//@interface YXIntelligenceQuestion_PaperTest_Pad_TeacherCheck : JSONModel
//
//@property (nonatomic, copy) NSString<Optional> *qcomment;
//@property (nonatomic, copy) NSString<Optional> *score;
//
//@end
//
//@interface YXIntelligenceQuestion_PaperTest_Pad : JSONModel
//
//@property (nonatomic, copy) NSString<Optional> *padid;
//@property (nonatomic, copy) NSString<Optional> *uid;
//@property (nonatomic, copy) NSString<Optional> *ptid;
//@property (nonatomic, copy) NSString<Optional> *status;
//@property (nonatomic, copy) NSString<Optional> *costtime;
//@property (nonatomic, copy) NSString<Optional> *answer;
//@property (nonatomic, copy) NSArray<Optional> *jsonAnswer;
//@property (nonatomic, strong) YXIntelligenceQuestion_PaperTest_Pad_TeacherCheck<Optional> *teachercheck;
//
//@end


@interface YXIntelligenceQuestion_PaperStatus : JSONModel

@property (nonatomic, copy) NSString<Optional> *paperstatusid;
@property (nonatomic, copy) NSString<Optional> *uid;
@property (nonatomic, copy) NSString<Optional> *tid;
@property (nonatomic, copy) NSString<Optional> *ppid;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *begintime;
@property (nonatomic, copy) NSString<Optional> *endtime;
@property (nonatomic, copy) NSString<Optional> *costtime;
@property (nonatomic, copy) NSString<Optional> *checkStatus;
@end


@interface YXIntelligenceQuestion_PaperTest : JSONModel

@property (nonatomic, copy) NSString<Optional> *paperid;
@property (nonatomic, copy) NSString<Optional> *qid;
@property (nonatomic, copy) NSString<Optional> *pid;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *sectionid;
@property (nonatomic, copy) NSString<Optional> *isfavorite;// 0,未收藏 1,收藏
@property (nonatomic, copy) NSString<Optional> *difficulty; // (1-5 分别标示 1容易， 2较易，3一般， 4 较难， 5 困难）(ver1.1)
@property (nonatomic, strong) YXQuestion<Optional> *questions;
@property (nonatomic, copy) NSString<Optional> *wqid;//翻页用
@property (nonatomic, copy) NSString<Optional> *wqnumber;//对应答题卡中题号
@property (nonatomic, copy) NSString<Optional> *redostatus;//0:没做过，1:练习过

//@property (nonatomic, copy) YXIntelligenceQuestion_PaperTest_Pad<Optional> *pad;
//@property (nonatomic, copy) YXIntelligenceQuestion_PaperTest_Extend<Optional> *extend;
- (void)clearMyAnswers;

@end

// 智能练习题目
@interface YXIntelligenceQuestion : JSONModel

@property (nonatomic, copy) NSString<Optional> *qid;
@property (nonatomic, copy) NSString<Optional> *ptype;
@property (nonatomic, copy) NSString<Optional> *authorid;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *subjectid;
@property (nonatomic, copy) NSString<Optional> *bedition;
@property (nonatomic, copy) NSString<Optional> *stageid;
@property (nonatomic, copy) NSString<Optional> *gradeid;
@property (nonatomic, copy) NSString<Optional> *volume;
@property (nonatomic, copy) NSString<Optional> *chapterid;
@property (nonatomic, copy) NSString<Optional> *sectionid;
@property (nonatomic, copy) NSString<Optional> *begintime;
@property (nonatomic, copy) NSString<Optional> *buildtime;
@property (nonatomic, copy) NSString<Optional> *quesnum;
@property (nonatomic, copy) NSString<Optional> *endtime;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSArray<YXIntelligenceQuestion_PaperTest, Optional> *paperTest;
@property (nonatomic, copy) YXIntelligenceQuestion_PaperStatus<Optional> *paperStatus;
@property (nonatomic, copy) NSString<Optional> *subjectName;
@property (nonatomic, copy) NSString<Optional> *editionName;
@property (nonatomic, copy) NSString<Optional> *volumeName;
@property (nonatomic, copy) NSString<Optional> *stageName;
@property (nonatomic, copy) NSString<Optional> *chapterName;
@property (nonatomic, copy) NSString<Optional> *cellid;
@property (nonatomic, copy) NSString<Optional> *showana;

- (NSTimeInterval)reportDuration;

@end

@protocol YXIntelligenceQuestion <NSObject>

@end

