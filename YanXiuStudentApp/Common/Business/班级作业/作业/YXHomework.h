//
//  YXHomework.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/28.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "JSONModel.h"

@interface YXHomework_PaperStatus : JSONModel

@property (nonatomic, copy) NSString<Optional> *ppid;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *tid;
@property (nonatomic, copy) NSString<Optional> *endtime;
@property (nonatomic, copy) NSString<Optional> *teachercomments;
@property (nonatomic, copy) NSString<Optional> *teacherName;

@end

@interface YXHomework_Group : JSONModel

@property (nonatomic, copy) NSString<Optional> *groupId;
@property (nonatomic, copy) NSString<Optional> *name;

@end

@protocol YXHomework <NSObject>

@end

//作业
@interface YXHomework : JSONModel

@property (nonatomic, copy) NSString<Optional> *paperId;
@property (nonatomic, copy) NSString<Optional> *ptype;
@property (nonatomic, copy) NSString<Optional> *authorid;
@property (nonatomic, copy) NSString<Optional> *name;      //作业名称
@property (nonatomic, copy) NSString<Optional> *subjectid; //学科id
@property (nonatomic, copy) NSString<Optional> *bedition;
@property (nonatomic, copy) NSString<Optional> *stageid;
@property (nonatomic, copy) NSString<Optional> *gradeid;
@property (nonatomic, copy) NSString<Optional> *buildtime;
@property (nonatomic, copy) NSString<Optional> *begintime;
@property (nonatomic, copy) NSString<Optional> *volume;    //册id
@property (nonatomic, copy) NSString<Optional> *chapterid; //章id
@property (nonatomic, copy) NSString<Optional> *sectionid; //节id
@property (nonatomic, copy) NSString<Optional> *quesnum;   //作业题数
@property (nonatomic, copy) YXHomework_PaperStatus<Optional> *paperStatus;
@property (nonatomic, copy) YXHomework_Group<Optional> *group;
@property (nonatomic, copy) NSString<Optional> *endtime;   //1437976959000
@property (nonatomic, copy) NSString<Optional> *status;    //状态
@property (nonatomic, copy) NSString<Optional> *overTime;  //07月27日14:02
@property (nonatomic, copy) NSString<Optional> *isEnd;
@property (nonatomic, copy) NSString<Optional> *showana;   //是否显示报告 0 显示 1 不显示
@property (nonatomic, copy) NSString<Optional> *answernum;
@property (nonatomic, copy) NSString<Optional> *remaindertimeStr;

- (BOOL)hasTeacherComments;
- (BOOL)shouldDisplayTheReport;
@end
