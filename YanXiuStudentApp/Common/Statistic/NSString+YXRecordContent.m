//
//  NSString+YXRecordContent.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/7/4.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "NSString+YXRecordContent.h"

@implementation NSString (YXRecordContent)
@dynamic formatContent;

- (NSString *)formatContent
{
    NSDictionary *dict = [self dictionary];
    NSDictionary *common = @{
                                 @"uid":@"",
                                 @"appkey":@"",
                                 @"eventID":@"",
                                 @"timestamp":@"",
                                 @"ip":@"",
                                 @"source":@"",
                                 @"clientType":@"",
                                 @"url":@"",
                                 @"resID":@"",
                                 };
    NSMutableDictionary *result = [NSMutableDictionary new];
    NSMutableDictionary *reserved = [NSMutableDictionary new];
    for (NSString *key in dict.allKeys) {
        id content = dict[key];
        if ([content isKindOfClass:[NSString class]]) {
            content = [content length]? content: @"";
        }
        if (common[key]) {
            [result putValue:content forKey:key];
        }else{
            [reserved putValue:content forKey:key];
        }
    }
    [result putValue:reserved forKey:@"reserved"];
    return result.JsonString;
}

@end
