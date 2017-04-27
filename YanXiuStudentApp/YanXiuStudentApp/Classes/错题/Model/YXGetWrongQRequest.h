//
//  YXGetWrongQRequest.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/27/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXIntelligenceQuestionListItem.h"

@interface YXGetWrongQRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *stageId;
@property (nonatomic, strong) NSString<Optional> *sectionId;
@property (nonatomic, strong) NSString<Optional> *subjectId;
@property (nonatomic, strong) NSString<Optional> *editionId;
@property (nonatomic, strong) NSString<Optional> *volumeId;
@property (nonatomic, strong) NSString<Optional> *chapterId;
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *currentPage;

@property (nonatomic, strong) NSString<Optional> *cellId;
@property (nonatomic, strong) NSString<Optional> *ptype;
@end
