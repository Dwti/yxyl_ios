//
//  HttpBaseRequest+YXTokenInvalidMethod.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/24.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "HttpBaseRequest.h"

@interface HttpBaseRequest (YXTokenInvalidMethod)

- (void)operationWithInvalidToken:(NSString *)token
                          retItem:(id)retItem
                            error:(NSError *)error
                    completeBlock:(HttpRequestCompleteBlock)completeBlock;

@end
