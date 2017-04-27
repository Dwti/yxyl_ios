//
//  NSObject+YXNetworkMethod.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/6.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YXNetworkMethod)

- (BOOL)isNetworkReachable;
- (BOOL)isNetworkReachableViaWiFi;

@end
