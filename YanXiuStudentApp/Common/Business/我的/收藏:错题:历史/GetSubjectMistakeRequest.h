//
//  GetSubjectMistakeRequest.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/11/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//  

#import "YXGetRequest.h"
@protocol GetSubjectMistakeRequestItem_subjectMistake_data <NSObject>
@end
@interface GetSubjectMistakeRequestItem_subjectMistake_data : JSONModel
@property (nonatomic, copy) NSString<Optional> *wrongQuestionsCount;
@property (nonatomic, copy) NSString<Optional> *editionId;
@property (nonatomic, copy) NSString<Optional> *chapterTag;   // 0：无章节标签 1：有章节标签
@property (nonatomic, copy) NSString<Optional> *pointTag;     // 0：无知识点标签 1：有知识点标签
@end


@protocol GetSubjectMistakeRequestItem_subjectMistake <NSObject>
@end
@interface GetSubjectMistakeRequestItem_subjectMistake : JSONModel
@property (nonatomic, copy) NSString<Optional> *subjectID;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, strong) GetSubjectMistakeRequestItem_subjectMistake_data<Optional> *data;
@end


@interface GetSubjectMistakeRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetSubjectMistakeRequestItem_subjectMistake,Optional> *subjectMistakes;
@end


@interface GetSubjectMistakeRequest : YXGetRequest
@property (nonatomic, copy) NSString *stageId;
@end
