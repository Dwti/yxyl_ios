//
//  MistakeListByQIDsRequest.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/31/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface MistakeListByQIDsRequest : YXGetRequest
@property (nonatomic, strong) NSString *qids;
@property (nonatomic, strong) NSString *subjectId;
@end
