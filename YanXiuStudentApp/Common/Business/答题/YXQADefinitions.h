//
//  YXQADefinitions.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/6.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#ifndef YXQADefinitions_h
#define YXQADefinitions_h

// 模版类型
typedef NS_ENUM(NSUInteger, YXQATemplateType) {
    YXQATemplateSingleChoose, // 单选
    YXQATemplateMultiChoose, // 多选
    YXQATemplateFill, // 填空
    YXQATemplateYesNo, // 判断
    YXQATemplateConnect, // 连线
    YXQATemplateClassify, // 归类
    YXQATemplateSubjective, // 主观，即问答
    
    YXQATemplateReadComplex, // 阅读复合题
    YXQATemplateClozeComplex, // 完形填空复合题
    YXQATemplateListenComplex, // 听力复合题
    
    YXQATemplateUnknown
};

// 题目类型
typedef NS_ENUM(NSUInteger, YXQAItemType) {
    YXQAItemSingleChoose = 1, //单选
    YXQAItemMultiChoose, //多选
    YXQAItemFill, //填空
    YXQAItemYesNo, //判断
    YXQAItemMaterial, //材料
    YXQAItemSubjective, //主观题,即问答题
    
    YXQAItemConnect, //连线
    YXQAItemCalculate, //计算
    YXQAItemListenAudioChoose, //听音选择
    YXQAItemListenAudioYesNo, //听音判断
    YXQAItemListenAudioConnect, //听音连线
    YXQAItemListenAudioFill, //听音填空
    YXQAItemClassify, //归类
    YXQAItemRead, //阅读理解
    YXQAItemCloze, //完形填空
    YXQAItemTranslate, //翻译
    YXQAItemCorrect, //改错
    YXQAItemListenChoose, //听力选择
    YXQAItemListenFill, //听力填空
    YXQAItemSort, //排序
    YXQAItemListenAudioSort, //听音排序
    YXQAItemSolve, //解答
    
//    YXQAItemClozeComplex, // 完形填空复合题
//    YXQAItemReadComplex, // 阅读理解复合题
//    YXQAItemSolveComplex, // 解答复合题
//    YXQAItemListenComplex, // 听力复合题
    
    YXQAItemUnknown //未知
};

// 答题状态
typedef NS_ENUM(NSUInteger, YXQAAnswerState) {
    YXAnswerStateNotAnswer, // 未作答
    YXAnswerStateCorrect, // 回答正确
    YXAnswerStateWrong, // 回答错误
    YXAnswerStateAnswered, // 已作答，用于主观题
    YXAnswerStateHalfCorrect, // 半对，用于主观题评分在1~4
    YXAnswerStatePartAnswer, // 做了一部分，用于填空题
    YXAnswerStateUnKnown // 未知
};

// 解析类型
typedef NS_ENUM(NSUInteger, YXQAAnalysisType) {
    YXAnalysisCurrentStatus, // 当前状态
    YXAnalysisStatistic, // 个人统计
    YXAnalysisDifficulty, // 难度
    YXAnalysisAnswer,     //答案
    YXAnalysisAnalysis, // 题目解析
    YXAnalysisKnowledgePoint, // 知识点
    YXAnalysisScore,  // 主观 非填空
    YXAnalysisResult, // 主观 填空
    YXAnalysisAudioComment, // 主观，语音批语
    YXAnalysisNote, // 错题重做，笔记批注
    YXAnalysisNoteImage, // 笔记图片
    YXAnalysisErrorReport, // 报错
    YXAnalysisUnknown, // 未知
};

// 选择题标记类型，用于选择题的解析
typedef NS_ENUM(NSUInteger, YXQAChooseMarkType) {
    YXQAChooseMarkCorrect, // 标记正确
    YXQAChooseMarkWrong, // 标记错误
    YXQAChooseMarkNone // 未做标记
};

// 判断题选择按钮样式
typedef NS_ENUM(NSUInteger, YXQAYesNoSchemeType) {
    YXQAYesNoSchemeCorrect, // 正确按钮样式
    YXQAYesNoSchemeWrong, // 错误按钮样式
    YXQAYesNoSchemeDefault // 默认样式
};


#endif /* YXQADefinitions_h */
