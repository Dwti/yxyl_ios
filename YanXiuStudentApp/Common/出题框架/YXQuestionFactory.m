//
//  YXQuestionFactory.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQuestionFactory.h"

@implementation YXQuestionFactory

+ (YXIntelligenceQuestion_PaperTest *)questionWithType:(YXQAItemType)type template:(YXQATemplateType)qTemplate{
    if (qTemplate == YXQATemplateSingleChoose) {
        return [self paperTestForQuestion:[YXQuestionFactory singleChooseQuestion]];
    }
    if (qTemplate == YXQATemplateMultiChoose) {
        return [self paperTestForQuestion:[YXQuestionFactory multiChooseQuestion]];
    }
    if (qTemplate == YXQATemplateYesNo) {
        return [self paperTestForQuestion:[YXQuestionFactory yesNoQuestion]];
    }
    if (qTemplate == YXQATemplateFill) {
        return [self paperTestForQuestion:[YXQuestionFactory fillBlankQuestion]];
    }
    if (qTemplate == YXQATemplateSubjective) {
        return [self paperTestForQuestion:[YXQuestionFactory subjectiveQuestion]];
    }
    if (qTemplate == YXQATemplateReadComplex) {
        if (type == YXQAItemSolve || type == YXQAItemCalculate) {
            return [self paperTestForQuestion:[YXQuestionFactory solveComplexQuestion]];
        }
        return [self paperTestForQuestion:[YXQuestionFactory readComplexQuestion]];
    }
    if (qTemplate == YXQATemplateClozeComplex) {
        return [self paperTestForQuestion:[YXQuestionFactory clozeComplexQuestion]];
    }
    if (qTemplate == YXQATemplateListenComplex) {
        return [self paperTestForQuestion:[YXQuestionFactory listenComplexQuestion]];
    }
    if (qTemplate == YXQATemplateClassify) {
        return [self paperTestForQuestion:[YXQuestionFactory classifyQuestion]];
    }
    if (qTemplate == YXQATemplateConnect) {
        return [self paperTestForQuestion:[YXQuestionFactory connectQuestion]];
    }
    
    return nil;
}

+ (YXIntelligenceQuestion_PaperTest *)paperTestForQuestion:(YXQuestion *)q{
    YXIntelligenceQuestion_PaperTest *paperTest = [[YXIntelligenceQuestion_PaperTest alloc]init];
    paperTest.questions = q;
    return paperTest;
}

// 单选
+ (YXQuestion *)singleChooseQuestion{
    YXQuestion *q = [[YXQuestion alloc]init];
    q.aid = [[NSUUID UUID]UUIDString];
    q.type_id = @"1";
    q.qTemplate = @"choice";
    q.stem = @"这是一道单选题";
    q.answer = @[@"0"];
    q.analysis = @"这是单选题的解析blablabla~~~";
    q.difficulty = @"3";
    
    YXQuestion_Content *content = [[YXQuestion_Content alloc]init];
    content.choices = @[@"这是选项aaa",@"这是选项bbb",@"这是选项ccc",@"这是选项ddd"];
    q.content = content;
    
    YXQuestion_Point *point = [[YXQuestion_Point alloc]init];
    point.name = @"考点1";
    q.point = (NSArray<YXQuestion_Point,Optional> *)@[point];
    
    YXQuestion_Pad *pad = [[YXQuestion_Pad alloc]init];
    pad.jsonAnswer = @[];
    q.pad = pad;
    
    YXQuestion_Extend *extend = [[YXQuestion_Extend alloc]init];
    YXQuestion_Extend_Data *extendData = [[YXQuestion_Extend_Data alloc]init];
    extendData.answerCompare = @"这是当前状态";
    extendData.globalStatis = @"这是个人统计";
    extend.data = extendData;
    q.extend = extend;
    
    return q;
}
// 多选
+ (YXQuestion *)multiChooseQuestion{
    YXQuestion *q = [[YXQuestion alloc]init];
    q.aid = [[NSUUID UUID]UUIDString];
    q.type_id = @"2";
    q.qTemplate = @"multi-choice";
    q.stem = @"这是一道多选题";
    q.answer = @[@"0",@"1"];
    q.analysis = @"这是多选题的解析blablabla~~~";
    q.difficulty = @"3";
    
    YXQuestion_Content *content = [[YXQuestion_Content alloc]init];
    content.choices = @[@"这是选项aaa",@"这是选项bbb",@"这是选项ccc",@"这是选项ddd"];
    q.content = content;
    
    YXQuestion_Point *point = [[YXQuestion_Point alloc]init];
    point.name = @"考点1";
    q.point = (NSArray<YXQuestion_Point,Optional> *)@[point];
    
    YXQuestion_Pad *pad = [[YXQuestion_Pad alloc]init];
    pad.jsonAnswer = @[];
    q.pad = pad;
    
    YXQuestion_Extend *extend = [[YXQuestion_Extend alloc]init];
    YXQuestion_Extend_Data *extendData = [[YXQuestion_Extend_Data alloc]init];
    extendData.answerCompare = @"这是当前状态";
    extendData.globalStatis = @"这是个人统计";
    extend.data = extendData;
    q.extend = extend;
    
    return q;
}

// 判断
+ (YXQuestion *)yesNoQuestion{
    YXQuestion *q = [[YXQuestion alloc]init];
    q.aid = [[NSUUID UUID]UUIDString];
    q.type_id = @"4";
    q.qTemplate = @"alter";
    q.stem = @"这是一道判断题";
    q.answer = @[@"1"];
    q.analysis = @"这是判断题的解析blablabla~~~";
    q.difficulty = @"3";
    
    YXQuestion_Point *point = [[YXQuestion_Point alloc]init];
    point.name = @"考点1";
    q.point = (NSArray<YXQuestion_Point,Optional> *)@[point];
    
    YXQuestion_Pad *pad = [[YXQuestion_Pad alloc]init];
    pad.jsonAnswer = @[];
    q.pad = pad;
    
    YXQuestion_Extend *extend = [[YXQuestion_Extend alloc]init];
    YXQuestion_Extend_Data *extendData = [[YXQuestion_Extend_Data alloc]init];
    extendData.answerCompare = @"这是当前状态";
    extendData.globalStatis = @"这是个人统计";
    extend.data = extendData;
    q.extend = extend;
    
    return q;
}

// 填空
+ (YXQuestion *)fillBlankQuestion{
    YXQuestion *q = [[YXQuestion alloc]init];
    q.aid = [[NSUUID UUID]UUIDString];
    q.type_id = @"3";
    q.qTemplate = @"fill";
    q.stem = @"这是一道填空题：请填第一个空 (_)，请填第二个空 (_)，请填第三个空 (_)";
//    q.stem = @"hello (_),L(_), ff(_)";
    q.answer = @[@"one",@"two",@"three"];
    q.analysis = @"这是填空题的解析blablabla~~~";
    q.difficulty = @"3";
    
    YXQuestion_Point *point = [[YXQuestion_Point alloc]init];
    point.name = @"考点1";
    q.point = (NSArray<YXQuestion_Point,Optional> *)@[point];
    
    YXQuestion_Pad *pad = [[YXQuestion_Pad alloc]init];
    pad.jsonAnswer = @[];
    q.pad = pad;
    
    YXQuestion_Extend *extend = [[YXQuestion_Extend alloc]init];
    YXQuestion_Extend_Data *extendData = [[YXQuestion_Extend_Data alloc]init];
    extendData.answerCompare = @"这是当前状态";
    extendData.globalStatis = @"这是个人统计";
    extend.data = extendData;
    q.extend = extend;
    
    return q;
}

// 新填空
+ (YXQuestion *)newFillBlankQuestion{
    YXQuestion *q = [[YXQuestion alloc]init];
    q.aid = [[NSUUID UUID]UUIDString];
    q.type_id = @"3";
    q.qTemplate = @"fill";
    q.stem = @"这是一道填空题：请填第一个空(_)，请填第二个空(_)，请填第三个空(_)<span style=\"color: #333333; font-family: 宋体, 'Microsoft YaHei', arial, sans-serif; font-size: 12px; line-height: 26px; background-color: #FFFFFF;\">如图，在等腰梯形ABCD中，AB∥DC，AD=BC=5cm，AB=12cm，CD=6cm，点Q从C开始沿CD边向D移动，速度是每秒1厘米，点P从A开始沿AB向B移动，速度是点Q速度的a倍，如果点P，Q分别从A，C同时出发，当其中一点到达终点时运动停止．设运动时间为t秒．已知当t=</span><img src=\"http://tiku.21cnjy.com/tikupic/c1/a2/c1da22e63296ca27f7a073a711490e33.png\" style=\"border: 0px; color: rgb(51, 51, 51); font-family: 宋体, 'Microsoft YaHei', arial, sans-serif; font-size: 12px; line-height: 26px; white-space: normal; vertical-align: middle; -webkit-user-select: text !important; background-color: rgb(255, 255, 255);\"/><span style=\"color: #333333; font-family: 宋体, 'Microsoft YaHei', arial, sans-serif; font-size: 12px; line-height: 26px; background-color: #FFFFFF;\">时，四边形APQD是平行四边形．<br/><img src=\"http://tiku.21cnjy.com/tikupic/b8/45/b80458c951161c0dd5fa1a5ed13252e3.png\"/></span>";
    q.answer = @[@"one",@"two",@"three"];
    q.analysis = @"这是填空题的解析blablabla~~~";
    q.difficulty = @"3";
    
    YXQuestion_Point *point = [[YXQuestion_Point alloc]init];
    point.name = @"考点1";
    q.point = (NSArray<YXQuestion_Point,Optional> *)@[point];
    
    YXQuestion_Pad *pad = [[YXQuestion_Pad alloc]init];
    pad.jsonAnswer = @[];
    q.pad = pad;
    
    YXQuestion_Extend *extend = [[YXQuestion_Extend alloc]init];
    YXQuestion_Extend_Data *extendData = [[YXQuestion_Extend_Data alloc]init];
    extendData.answerCompare = @"这是当前状态";
    extendData.globalStatis = @"这是个人统计";
    extend.data = extendData;
    q.extend = extend;
    
    return q;
}

// 主观题
+ (YXQuestion *)subjectiveQuestion{
    YXQuestion *q = [[YXQuestion alloc]init];
    q.aid = [[NSUUID UUID]UUIDString];
    q.type_id = @"3";
    q.qTemplate = @"answer";
    q.stem = @"这是一道主观题--请完成老师留下的作业~~~(_)";
    q.analysis = @"这是主观题的解析blablabla~~~";
    q.difficulty = @"3";
    
    YXQuestion_Point *point = [[YXQuestion_Point alloc]init];
    point.name = @"考点1";
    q.point = (NSArray<YXQuestion_Point,Optional> *)@[point];
    
    YXQuestion_Pad *pad = [[YXQuestion_Pad alloc]init];
    pad.jsonAnswer = @[];
    YXQuestion_Pad_TeacherCheck *tc = [[YXQuestion_Pad_TeacherCheck alloc]init];
    pad.teachercheck = tc;
    q.pad = pad;
    
    YXQuestion_Extend *extend = [[YXQuestion_Extend alloc]init];
    YXQuestion_Extend_Data *extendData = [[YXQuestion_Extend_Data alloc]init];
    extendData.answerCompare = @"这是当前状态";
    extendData.globalStatis = @"这是个人统计";
    extend.data = extendData;
    q.extend = extend;
    
    return q;
}

// 阅读理解
+ (YXQuestion *)readComplexQuestion{
    YXQuestion *q = [[YXQuestion alloc]init];
    q.type_id = @"14";
    q.qTemplate = @"multi";
    q.stem = @"这是一道复合题 :---首节开打，美国队延续了之前几场的慢热。尽管，杜兰特和巴恩斯的三分球，一度帮他们9-2领先。但在防守端，梦之队却表现的非常松散，尼日利亚这边，尤佐突破暴扣得手，尼日利亚将分差迫近到1分。";
    YXQuestion_Pad *pad = [[YXQuestion_Pad alloc]init];
    pad.jsonAnswer = @[];
    q.pad = pad;
    
    q.children = (NSArray<YXIntelligenceQuestion_PaperTest,Optional> *)@[[self paperTestForQuestion:[YXQuestionFactory singleChooseQuestion]]];
    
    return q;
}

// 解答题
+ (YXQuestion *)solveComplexQuestion{
    YXQuestion *q = [[YXQuestion alloc]init];
    q.type_id = @"22";
    q.qTemplate = @"multi";
    q.stem = @"这是一道解答题 :请证明1+1=2";
    
    YXQuestion_Pad *pad = [[YXQuestion_Pad alloc]init];
    pad.jsonAnswer = @[];
    q.pad = pad;
    
    q.children = (NSArray<YXIntelligenceQuestion_PaperTest,Optional> *)@[[self paperTestForQuestion:[YXQuestionFactory singleChooseQuestion]]];
    
    return q;
}

// 完形填空题
+ (YXQuestion *)clozeComplexQuestion{
    YXQuestion *q = [[YXQuestion alloc]init];
    q.type_id = @"15";
    q.qTemplate = @"cloze";
    q.stem = @"这是一道完形填空题 :第1道题howfhoehogoi hoi hgo hie hio45h o45 hoi45 hyio45 ho4i5 hyo4 的答案是 (_).";
    
    YXQuestion_Pad *pad = [[YXQuestion_Pad alloc]init];
    pad.jsonAnswer = @[];
    q.pad = pad;
    
    q.children = (NSArray<YXIntelligenceQuestion_PaperTest,Optional> *)@[[self paperTestForQuestion:[YXQuestionFactory singleChooseQuestion]]];
    
    return q;
}

// 听力复合题
+ (YXQuestion *)listenComplexQuestion{
    YXQuestion *q = [[YXQuestion alloc]init];
    q.type_id = @"9";
    q.qTemplate = @"listen";
    q.stem = @"这是一道听力复合题 :请听下面录音并完成问题";
    q.url = @"http://data.5sing.kgimg.com/G034/M05/16/17/ApQEAFXsgeqIXl7gAAVVd-n31lcAABOogKzlD4ABVWP363.mp3";
    q.url = @"http://data.5sing.kgimg.com/G064/M0B/16/1B/IJQEAFeZk5qAW5N1AJhfREa5tSk663.mp3";
    
    YXQuestion_Pad *pad = [[YXQuestion_Pad alloc]init];
    pad.jsonAnswer = @[];
    q.pad = pad;
    
    q.children = (NSArray<YXIntelligenceQuestion_PaperTest,Optional> *)@[[self paperTestForQuestion:[YXQuestionFactory singleChooseQuestion]]];
    
    return q;
}

// 归类
+ (YXQuestion *)classifyQuestion{
    YXQuestion *q = [[YXQuestion alloc]init];
    q.aid = [[NSUUID UUID]UUIDString];
    q.type_id = @"13";
    q.qTemplate = @"classify";
    q.stem = @"这是一道归类题";
    NSDictionary *a1 = [self classifyAnswerWithName:@"水果" answer:@"0,1"];
    NSDictionary *a2 = [self classifyAnswerWithName:@"汽车" answer:@"2,3"];
    q.answer = @[a1,a2];
    q.analysis = @"这是归类题的解析blablabla~~~";
    q.difficulty = @"3";
    
    YXQuestion_Content *content = [[YXQuestion_Content alloc]init];
    content.choices = @[@"苹果",@"梨",@"奔驰",@"宝马"];
    q.content = content;
    
    YXQuestion_Point *point = [[YXQuestion_Point alloc]init];
    point.name = @"考点1";
    q.point = (NSArray<YXQuestion_Point,Optional> *)@[point];
    
    YXQuestion_Pad *pad = [[YXQuestion_Pad alloc]init];
    pad.jsonAnswer = @[];
    q.pad = pad;
    
    YXQuestion_Extend *extend = [[YXQuestion_Extend alloc]init];
    YXQuestion_Extend_Data *extendData = [[YXQuestion_Extend_Data alloc]init];
    extendData.answerCompare = @"这是当前状态";
    extendData.globalStatis = @"这是个人统计";
    extend.data = extendData;
    q.extend = extend;
    
    return q;
}

+ (NSDictionary *)classifyAnswerWithName:(NSString *)name answer:(NSString *)answer{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:name forKey:@"name"];
    [dic setValue:answer forKey:@"answer"];
    return dic;
}

// 连线
+ (YXQuestion *)connectQuestion{
    YXQuestion *q = [[YXQuestion alloc]init];
    q.aid = [[NSUUID UUID]UUIDString];
    q.type_id = @"7";
    q.qTemplate = @"connect";
    q.stem = @"这是一道连线题";
    NSDictionary *a1 = [self connectAnswerWithAnswer:@"0,2"];
    NSDictionary *a2 = [self connectAnswerWithAnswer:@"1,3"];
    q.answer = @[a1,a2];
    q.analysis = @"这是连线题的解析blablabla~~~";
    q.difficulty = @"3";
    //<p>函数<img src=\"http://scc.jsyxw.cn/image/qs/47/1850047/852865a8bf937ce39b5b9cebfcac5a55.png\" >的定义域是（　　）</p>
    YXQuestion_Content *content = [[YXQuestion_Content alloc]init];
    content.choices = @[@"中国",@"法国",@"<p>函数<img src=\"http://scc.jsyxw.cn/image/qs/47/1850047/852865a8bf937ce39b5b9cebfcac5a55.png\" >的定义域是（　　）</p>",@"欧洲"];
    q.content = content;
    
    YXQuestion_Point *point = [[YXQuestion_Point alloc]init];
    point.name = @"考点1";
    q.point = (NSArray<YXQuestion_Point,Optional> *)@[point];
    
    YXQuestion_Pad *pad = [[YXQuestion_Pad alloc]init];
    pad.jsonAnswer = @[];
    q.pad = pad;
    
    YXQuestion_Extend *extend = [[YXQuestion_Extend alloc]init];
    YXQuestion_Extend_Data *extendData = [[YXQuestion_Extend_Data alloc]init];
    extendData.answerCompare = @"这是当前状态";
    extendData.globalStatis = @"这是个人统计";
    extend.data = extendData;
    q.extend = extend;
    
    return q;
}

+ (NSDictionary *)connectAnswerWithAnswer:(NSString *)answer{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:answer forKey:@"answer"];
    return dic;
}

@end
