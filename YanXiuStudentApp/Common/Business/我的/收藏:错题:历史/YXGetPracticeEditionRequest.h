//
//  YXGetPracticeEditionRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/13.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetPracticeEditionRequestItem_subject_edition : JSONModel
@property (nonatomic, copy) NSString<Optional> *editionId;
@property (nonatomic, copy) NSString<Optional> *editionName;
@property (nonatomic, copy) NSString<Optional> *has_knp;
@end

@protocol GetPracticeEditionRequestItem_subject <NSObject>
@end
@interface GetPracticeEditionRequestItem_subject : JSONModel
@property (nonatomic, copy) NSString<Optional> *subjectID;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, strong) GetPracticeEditionRequestItem_subject_edition<Optional> *edition;
@end

@interface GetPracticeEditionRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetPracticeEditionRequestItem_subject,Optional> *subjects;
@end

// 获取练习历史教材版本
@interface YXGetPracticeEditionRequest : YXGetRequest

@property (nonatomic, strong) NSString *stageId; //学段Id

@end
