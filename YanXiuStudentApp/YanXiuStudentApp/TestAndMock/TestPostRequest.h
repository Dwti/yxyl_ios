//
//  TestPostRequest.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/2/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "PostRequest.h"

@interface TestPostRequest : PostRequest
@property (nonatomic, strong) NSString<Optional> *token;
@property (nonatomic, strong) NSString<Optional> *pid;
@property (nonatomic, strong) NSString<Optional> *puid;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *islike;
@end
