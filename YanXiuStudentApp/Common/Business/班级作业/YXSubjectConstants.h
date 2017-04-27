//
//  YXSubjectConstants.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/3/18.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// 学科
typedef NS_ENUM(NSInteger, YXSubjectType) {
    YXSubjectTypeChinese = 1102,   //语文
    YXSubjectTypeMath = 1103,      //数学
    YXSubjectTypeEnglish = 1104,   //英语
    YXSubjectTypePhysics = 1105,   //物理
    YXSubjectTypeChemistry = 1106, //化学
    YXSubjectTypeBiology = 1107,   //生物
    YXSubjectTypeGeography = 1108, //地理
    YXSubjectTypePolitics = 1109,  //政治
    YXSubjectTypeHistory = 1110,   //历史
};

@interface YXSubjectConstants : NSObject

// 学科Id对应的学科名称
+ (NSString *)subjectNameWithType:(YXSubjectType)type;

@end
