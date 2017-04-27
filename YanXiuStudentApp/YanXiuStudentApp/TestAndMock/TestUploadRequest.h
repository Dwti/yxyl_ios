//
//  TestUploadRequest.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/2/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "UploadRequest.h"

@interface TestUploadRequest : UploadRequest
@property (nonatomic, copy) NSString<Optional> *action;
@property (nonatomic, copy) NSString<Optional> *token;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *hashCode;
@end
