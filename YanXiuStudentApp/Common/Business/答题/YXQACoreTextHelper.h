//
//  YXQACoreTextHelper.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/4.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXQACoreTextHelper : NSObject

/**
 *  获得答题里面coretext的默认显示格式的属性字符串
 *
 *  @param string 传入的带html标签的文本
 *
 *  @return 返回加上了答题里面默认显示格式的属性字符串
 */
+ (NSAttributedString *)attributedStringForString:(NSString *)string;


// 内容居中的
+ (NSAttributedString *)centerAttributedStringForString:(NSString *)string;

/**
 *  获得coretext字符串的显示高度
 *
 *  @param string 传入的带html标签的文本
 *  @param width  显示宽度限制
 *
 *  @return 该字符串显示需要的高度
 */
+ (CGFloat)heightForString:(NSString *)string constraintedToWidth:(CGFloat)width;

+ (NSAttributedString *)labelUsedAttributedStringForString:(NSString *)string;

#pragma mark - 3.0 new
//用于一级题干
+ (NSDictionary *)defaultOptionsForLevel1;
//用于二级题干
+ (NSDictionary *)defaultOptionsForLevel2;
//用于其他，比如选项
+ (NSDictionary *)defaultOptionsForLevel3;
//用于标识正确，如作答正确的选项
+ (NSDictionary *)defaultOptionsForLevel3_Correct;
//用于标识错误，如作答错误的选项
+ (NSDictionary *)defaultOptionsForLevel3_Wrong;
//用于完形填空
+ (NSDictionary *)optionsForClozeStem;
//用于解析项
+ (NSDictionary *)defaultOptionsForAnalysisItems;
//用于解析中 作答结果项
+ (NSDictionary *)defaultOptionsForAnalysisResultItem;
+ (CGFloat)heightForString:(NSString *)string options:(NSDictionary *)option width:(CGFloat)width;
+ (NSAttributedString *)attributedStringWithString:(NSString *)string options:(NSDictionary *)option;

@end
