//
//  NSObject+YXNetworkMethod.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/6.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "NSObject+YXNetworkMethod.h"
#import <Reachability/Reachability.h>

@implementation NSObject (YXNetworkMethod)

- (BOOL)isNetworkReachable
{
    return [[Reachability reachabilityForInternetConnection] isReachable];
}

- (BOOL)isNetworkReachableViaWiFi
{
    return [[Reachability reachabilityForInternetConnection] isReachableViaWiFi];
}

@end
