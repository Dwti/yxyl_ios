//
//  YXUploadRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "UploadRequest.h"

@interface YXUploadRequest : UploadRequest

@property (nonatomic, strong) NSString<Optional> *token;
@property (nonatomic, strong) NSString<Optional> *trace_uid;

@end
