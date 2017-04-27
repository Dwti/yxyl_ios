//
//  SaveEditionRequest.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@interface SaveEditionRequest : YXGetRequest
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *beditionId;
@end
