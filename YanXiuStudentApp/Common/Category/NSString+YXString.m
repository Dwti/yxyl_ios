//
//  NSString+YXString.m
//  YXKit
//
//  Created by ChenJianjun on 15/5/12.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "NSString+YXString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (YXString)

@dynamic dictionary;

- (BOOL)yx_isValidString
{
    if (nil == self
        || ![self isKindOfClass:[NSString class]]
        || [self yx_stringByTrimmingCharacters].length <= 0) {
        return NO;
    }
    return YES;
}

- (NSString *)yx_safeString
{
    if ([self yx_isValidString]) {
        return self;
    }
    return @"";
}

- (NSString *)yx_stringByTrimmingCharacters
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)yx_encodeString
{
    CFStringRef stringFef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                    (__bridge CFStringRef)self,
                                                                    NULL,
                                                                    (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                    kCFStringEncodingUTF8);
    return (__bridge_transfer NSString *)stringFef;
}

- (NSString *)yx_decodeString
{
    NSMutableString *resultString = [NSMutableString stringWithString:self];
    [resultString replaceOccurrencesOfString:@"+"
                                  withString:@" "
                                     options:NSLiteralSearch
                                       range:NSMakeRange(0, [resultString length])];
    return [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation NSString (YXTextChecking)

- (BOOL)yx_textCheckingWithPattern:(NSString *)pattern
{
    if ([pattern yx_isValidString]
        && [self yx_isValidString]) {
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSTextCheckingResult *firstMacth = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
        if (firstMacth) {
            return YES;
        }
    }
    return NO;
}

/*
 * ^[1]，首字母必须是1
 * [3-8]，第二个数字为3-8之间
 * +，表示至少一个[3-8]
 * \\d，表示数字
 * {9}，表示后面包含9个数字
 * $，结束符
 */
- (BOOL)yx_isPhoneNum
{
    NSString *phoneNum = [self yx_stringByTrimmingCharacters];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    return (phoneNum.length == 11) && [phoneNum yx_textCheckingWithPattern:@"^[1][3-8]+\\d{9}$"];
}

- (BOOL)yx_isHttpLink
{
    if (![self yx_isValidString]) {
        return NO;
    }
    NSString *link = [self yx_stringByTrimmingCharacters];
    if ([link hasPrefix:@"http"]
        || [link hasPrefix:@"https"]
        || [link hasPrefix:@"www."]) {
        return YES;
    }
    return NO;
}

- (NSString *)yx_md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

- (BOOL)nyx_isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (NSDictionary *)dictionary{
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
