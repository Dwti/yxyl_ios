//
//  GetSubjectRequest.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetSubjectRequestItem_subject_edition : JSONModel
@property (nonatomic, copy) NSString<Optional> *editionId;
@property (nonatomic, copy) NSString<Optional> *editionName;
@end

@protocol GetSubjectRequestItem_subject <NSObject>
@end
@interface GetSubjectRequestItem_subject : JSONModel
@property (nonatomic, copy) NSString<Optional> *subjectID;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, strong) GetSubjectRequestItem_subject_edition<Optional> *edition;
@end

@interface GetSubjectRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetSubjectRequestItem_subject,Optional> *subjects;
@end

@interface GetSubjectRequest : YXGetRequest
@property (nonatomic, copy) NSString *stageId;
@end
