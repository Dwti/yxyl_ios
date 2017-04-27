//
//  TestGetRequest.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/2/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "TestGetRequest.h"

@implementation TestGetRequest
- (id)init {
    self = [super init];
    if (self) {
        self.urlHead = @"http://mobile.yanxiu.com/api/cooperate/list";
    }
    return self;
}

- (void)startRequestWithRetClass:(Class)retClass
                andCompleteBlock:(HttpRequestCompleteBlock)completeBlock {
    [super startRequestWithRetClass:retClass andCompleteBlock:completeBlock];
    DDLogWarn(@"request : %@", [self request].url);
}

- (void)dealWithResponseJson:(NSString *)json {
    DDLogError(@"%@", json);
    [super dealWithResponseJson:json];
}

@end
