//
//  YXQuestion.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/13.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "JSONModel.h"

@interface YXQuestion_Content : JSONModel

@property (nonatomic, copy) NSArray<Optional> *choices;
@property (nonatomic, strong) NSArray<Optional> *answer;

@end

@protocol YXQuestion_Point <NSObject>

@end

@interface YXQuestion_Point : JSONModel

@property (nonatomic, copy) NSString<Optional> *pid;
@property (nonatomic, copy) NSString<Optional> *name;

@end

@protocol YXQuestion <NSObject>

@end

@interface YXQuestion_Extend_Data : JSONModel

@property (nonatomic, copy) NSString<Optional> *globalStatis;
@property (nonatomic, copy) NSString<Optional> *answerCompare;

@end

@interface YXQuestion_Extend : JSONModel

@property (nonatomic, copy) YXQuestion_Extend_Data<Optional> *data;

@end

@interface YXQuestion_Pad_TeacherCheck : JSONModel

@property (nonatomic, copy) NSString<Optional> *qcomment;
@property (nonatomic, copy) NSString<Optional> *score;

@end

@protocol YXQuestion_Pad_AudioComment <NSObject>
@end
@interface YXQuestion_Pad_AudioComment : JSONModel
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString *length;
@end

@interface YXQuestion_Pad : JSONModel
@property (nonatomic, copy) NSString<Optional> *padid;
@property (nonatomic, copy) NSString<Optional> *uid;
@property (nonatomic, copy) NSString<Optional> *ptid;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *costtime;
@property (nonatomic, copy) NSString<Optional> *answer;
@property (nonatomic, strong) NSArray<Optional> *jsonAnswer;
@property (nonatomic, strong) NSString<Optional> *objectiveScore;
@property (nonatomic, strong) YXQuestion_Pad_TeacherCheck<Optional> *teachercheck;
@property (nonatomic, strong) NSArray<YXQuestion_Pad_AudioComment,Optional> *jsonAudioComment;
@end

@interface YXQuestion_jsonNote : JSONModel
@property (nonatomic, copy) NSString<Optional> *text;
@property (nonatomic, copy) NSArray<Optional> *images;
@end

@protocol YXIntelligenceQuestion_PaperTest <NSObject>@end

@interface YXQuestion : JSONModel
@property (nonatomic, copy) NSString<Optional> *aid;       //练习Id
@property (nonatomic, copy) NSString<Optional> *stem;      //题干
@property (nonatomic, copy) NSString<Optional> *type_id;   //类型
@property (nonatomic, strong) YXQuestion_Content<Optional> *content;     //选项
@property (nonatomic, strong) NSArray<YXQuestion_Point,Optional> *point; //知识点
@property (nonatomic, strong) NSArray<Optional> *answer;   //试题答案
@property (nonatomic, copy) NSString<Optional> *qTemplate; //模版
@property (nonatomic, copy) NSString<Optional> *analysis;  //试题解析
@property (nonatomic, strong) NSArray<YXIntelligenceQuestion_PaperTest,Optional> *children;
@property (nonatomic, copy) NSString<Optional> *difficulty; // (1-5 分别标示 1容易， 2较易，3一般， 4 较难， 5 困难）(ver1.1)
@property (nonatomic, copy) YXQuestion_Pad<Optional> *pad;
@property (nonatomic, copy) YXQuestion_Extend<Optional> *extend;
@property (nonatomic, copy) NSString<Optional> *url;  //听力url
@property (nonatomic, strong) NSString<Optional> *identifierForTest; // 并非server返回字段，仅用于测试
@property (nonatomic, copy) NSString<Optional> *wqid;//听说加上这个请求错题就不会为空了
@property (nonatomic, strong) YXQuestion_jsonNote<Optional> *jsonNote;// 错题笔记

//仅用于BC资源
@property (nonatomic, copy) NSString<Optional> *has_video;//- 本题是否有视频 1有


- (YXQAItemType)questionType;
- (YXQATemplateType)templateType;
- (NSString *)completeStem; // 仅用于出题框架
@end


