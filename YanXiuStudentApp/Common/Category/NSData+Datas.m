//
//  NSData+Datas.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/9/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "NSData+Datas.h"

@implementation NSData (Datas)

- (NSDictionary *)leanCloudDictionary
{
    NSString *dictStr = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [dictStr dictionary];
    NSArray *datas = dict[@"results"];
    NSMutableDictionary *dicts = [NSMutableDictionary new];
    for (id object in datas) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            [dicts setDictionary:object];
        }
    }
    return dicts;
}

@end
