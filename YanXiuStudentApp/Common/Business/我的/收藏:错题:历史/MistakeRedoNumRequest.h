//
//  MistakeRedoNumRequest.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/6/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@interface MistakeRedoNumProterty : JSONModel
@property (nonatomic, copy) NSString<Optional> *questionNum;
@end

@interface MistakeRedoNumItem : HttpBaseRequestItem
@property (nonatomic, copy) MistakeRedoNumProterty<Optional> *property;
@end

@interface MistakeRedoNumRequest : YXGetRequest
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, copy) NSString *subjectId;
@end

