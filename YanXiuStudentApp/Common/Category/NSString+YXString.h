//
//  NSString+YXString.h
//  YXKit
//
//  Created by ChenJianjun on 15/5/12.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YXString)

@property (nonatomic, weak, readonly) NSDictionary *dictionary;

// 是否为有效字符串
- (BOOL)yx_isValidString;

// 安全字符串
- (NSString *)yx_safeString;

// 去除字符串两端的空格及换行
- (NSString *)yx_stringByTrimmingCharacters;


#pragma mark - encode & decode

// 字符串编码
- (NSString *)yx_encodeString;

// 字符串解码
- (NSString *)yx_decodeString;

@end

@interface NSString (YXTextChecking)

// 正则表达式判断
- (BOOL)yx_textCheckingWithPattern:(NSString *)pattern;

// 是否为手机号
- (BOOL)yx_isPhoneNum;

// 是否为http链接
- (BOOL)yx_isHttpLink;

// 加密
- (NSString *)yx_md5;

@end