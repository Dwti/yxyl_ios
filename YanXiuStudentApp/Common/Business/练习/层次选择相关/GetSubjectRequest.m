//
//  GetSubjectRequest.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "GetSubjectRequest.h"

@implementation GetSubjectRequestItem_subject_edition

@end

@implementation GetSubjectRequestItem_subject
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"subjectID":@"id",
                                                                  @"edition":@"data"
                                                                  }];
}
@end

@implementation GetSubjectRequestItem
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"subjects":@"data"}];
}
@end

@implementation GetSubjectRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/common/getSubject.do"];
    }
    return self;
}
@end
