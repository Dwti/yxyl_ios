//
//  TestGetRequest.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/2/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "GetRequest.h"

@interface TestGetRequest : GetRequest
@property (nonatomic, copy) NSString<Optional> *token;
@property (nonatomic, copy) NSString<Optional> *noUseParam;
@end
