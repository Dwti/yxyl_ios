//
//  NSObject+YXHookMethod.h
//  YXUserStatistics
//
//  Created by ChenJianjun on 16/5/26.
//  Copyright © 2016年 yanxiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YXHookMethod)

- (void)swizzlingInClass:(Class)cls
        originalSelector:(SEL)originalSelector
        swizzledSelector:(SEL)swizzledSelector;

@end
