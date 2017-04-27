//
//  NSMutableDictionary+YXDictionarys.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/17.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "NSMutableDictionary+YXDictionarys.h"

@implementation NSMutableDictionary (YXDictionarys)
-(BOOL)putValue:(id)value forKey:(id<NSCopying>)aKey{
    if (value && aKey) {
        [self setObject:value forKey:aKey];
    }else{
        NSLog(@"为字典设置值失败！");
        return NO;
    }
    return YES;
}
@end
