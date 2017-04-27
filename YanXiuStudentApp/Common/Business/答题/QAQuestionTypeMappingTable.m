//
//  QAQuestionTypeMappingTable.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/14.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAQuestionTypeMappingTable.h"

@implementation QAQuestionTypeMappingTable
+ (NSString *)typeNameForType:(YXQAItemType)type{
    NSDictionary *mappingDic = @{@"1":@"单选题",
                                 @"2":@"多选题",
                                 @"3":@"填空题",
                                 @"4":@"判断题",
                                 @"5":@"材料阅读",
                                 @"6":@"问答题",
                                 @"7":@"连线题",
                                 @"8":@"计算题",
                                 @"9":@"听力题",
                                 @"10":@"听力题",
                                 @"11":@"听力题",
                                 @"12":@"听力题",
                                 @"13":@"归类题",
                                 @"14":@"阅读理解",
                                 @"15":@"完形填空",
                                 @"16":@"翻译题",
                                 @"17":@"改错题",
                                 @"18":@"听力题",
                                 @"19":@"听力题",
                                 @"20":@"排序题",
                                 @"21":@"听力题",
                                 @"22":@"解答题"};
    NSString *key = [NSString stringWithFormat:@"%@",@(type)];
    return [mappingDic valueForKey:key];
}

+ (YXQAItemType)typeForTypeID:(NSString *)typeID{
    NSInteger typeValue = typeID.integerValue;
    if (typeValue >= YXQAItemUnknown) {
        return YXQAItemUnknown;
    }
    return typeValue;
}

@end
