//
//  YXQuestionTemplateTypeMapper.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/8.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQuestionTemplateTypeMapper.h"

@implementation YXQuestionTemplateTypeMapper

+ (NSDictionary *)questionTemplateDictionary{
    NSDictionary *mappingDic = @{@"choice":@"单选",
                                 @"multi-choice":@"多选",
                                 @"alter":@"判断",
                                 @"fill":@"填空",
                                 @"new-fill":@"新填空",
                                 @"answer":@"问答",
                                 @"multi":@"复合",
                                 @"listen":@"听力",
                                 @"cloze":@"完形填空",
                                 @"classify":@"归类",
                                 @"connect":@"连线",
                                 @"oral":@"口语"};
    return mappingDic;
}

+ (NSDictionary *)questionTypeDictionary{
    NSDictionary *mappingDic = @{@"1":@"单选题",
                                 @"2":@"多选题",
                                 @"3":@"填空题",
                                 @"4":@"判断题",
                                 @"5":@"材料阅读",
                                 @"6":@"问答题",
                                 @"7":@"连线题",
                                 @"8":@"计算题",
                                 @"9":@"听音选择",
                                 @"10":@"听音判断",
                                 @"11":@"听音连线",
                                 @"12":@"听音填空",
                                 @"13":@"归类题",
                                 @"14":@"阅读理解",
                                 @"15":@"完形填空",
                                 @"16":@"翻译题",
                                 @"17":@"改错题",
                                 @"18":@"听力选择",
                                 @"19":@"听力填空",
                                 @"20":@"排序题",
                                 @"21":@"听音排序",
                                 @"22":@"解答题",
                                 @"23":@"朗读题",
                                 @"24":@"跟读题",
                                 @"25":@"对话题",
                                 @"26":@"作文题"};
    return mappingDic;
}

+ (NSDictionary *)questionTemplateTypeMapDictionary{
    NSDictionary *mappingDic = @{@"choice":@"1",
                                 @"multi-choice":@"2",
                                 @"alter":@"4",
                                 @"fill":@"3,16,20,17",
                                 @"new-fill":@"3,16,20,17",
                                 @"answer":@"3,22,8,6",
                                 @"multi":@"14,22,8,5",
                                 @"listen":@"9,10,11,12,18,19,21",
                                 @"cloze":@"15",
                                 @"classify":@"13",
                                 @"connect":@"7",
                                 @"oral":@"23,24,25,26"};
    return mappingDic;
}

@end
