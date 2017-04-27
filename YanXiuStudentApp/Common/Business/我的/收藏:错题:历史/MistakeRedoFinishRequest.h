//
//  MistakeRedoFinishRequest.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/3/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@interface MistakeRedoFinishRequest : YXPostRequest
@property (nonatomic, strong) NSString *stageId;
@property (nonatomic, strong) NSString *subjectId;
@property (nonatomic, strong) NSString *lastWqid;
@property (nonatomic, strong) NSString *lastWqnumber;
@property (nonatomic, strong) NSString *deleteWqidList;
@end
