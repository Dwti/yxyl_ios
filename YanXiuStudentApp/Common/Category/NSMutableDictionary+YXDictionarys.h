//
//  NSMutableDictionary+YXDictionarys.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/17.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (YXDictionarys)
-(BOOL)putValue:(id)value forKey:(id<NSCopying>)aKey;
@end
