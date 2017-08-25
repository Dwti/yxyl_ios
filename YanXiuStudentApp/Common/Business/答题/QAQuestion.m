//
//  QAQuestion.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAQuestion.h"
#import "QAImageAnswerQuestion.h"


@implementation QAAudioComment

@end
@implementation QAQuestionPosition

@end
@implementation QAKnowledgePoint

@end

static NSString * const kAnswerMarkedFlag = @"5";

@implementation QAQuestion
- (instancetype)initWithRawData:(YXIntelligenceQuestion_PaperTest *)rawData{
    if (self = [super init]) {
        [self setupWithRawData:rawData];
    }
    return self;
}

- (void)setupWithRawData:(YXIntelligenceQuestion_PaperTest *)rawData{
    YXQuestion *question = rawData.questions;

    self.questionType = [QAQuestionTypeMappingTable typeForTypeID:question.type_id];
    self.templateType = [QAQuestionTemplateMappingTable templateTypeForTemplate:question.qTemplate];
    self.testID = rawData.paperid;
    self.answerDetailID = question.pad.padid;
    self.questionID = rawData.qid;
    self.wrongQuestionID = rawData.wqid;
    self.paperID = rawData.pid;
    self.isFavorite = rawData.isfavorite.boolValue;
    self.audioUrl = question.url;
    self.stem = [self adjustedStemForStem:[question completeStem]];
    self.options = question.content.choices;
    self.difficulty = question.difficulty;
    self.answerDetailID = question.pad.padid;
    self.analysis = question.analysis;
    self.correctAnswers = question.answer;
    self.globalStatis = question.extend.data.globalStatis;
    self.answerCompare = question.extend.data.answerCompare;
    self.isMarked = [self isAnswerMarkedWithStatus:question.pad.status];
    self.comment = question.pad.teachercheck.qcomment;
    self.score = question.pad.teachercheck.score.floatValue;
    self.answerDuration = question.pad.costtime.doubleValue;
    self.audioComments = [self audioCommentsWithRawData:question.pad.jsonAudioComment];
    self.knowledgePoints = [self knowledgePointsWithRawPoints:question.point];
    self.correctAnswers = [self correctAnswersWithRawData:question];
    self.myAnswers = [self myAnswersWithRawData:question];
    self.childQuestions = [self childQuestionsWithRawDatas:question.children];
    self.wrongQuestionIndex = rawData.wqnumber.integerValue;
    self.redoCompleted = rawData.redostatus.boolValue;
    self.noteText = question.jsonNote.text;
    self.noteImages = [self noteImagesAnswerWithRawData:question.jsonNote.images];
}

- (NSString *)adjustedStemForStem:(NSString *)stem {
    NSString *adjustedStem = stem;
    if (isEmpty(adjustedStem)) {
        return adjustedStem;
    }
    adjustedStem = [adjustedStem stringByReplacingOccurrencesOfString:@"(_)" withString:@"(_)&nbsp;"];
    NSString *pattern = @"\\S{2,}\\(_\\)";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSTextCheckingResult *result = [reg firstMatchInString:adjustedStem options:NSMatchingReportCompletion range:NSMakeRange(0, adjustedStem.length)];
    while (result) {
        NSRange range = result.range;
        adjustedStem = [adjustedStem stringByReplacingCharactersInRange:NSMakeRange(range.location+range.length-3, 3) withString:@"&nbsp; (_)"];
        result = [reg firstMatchInString:adjustedStem options:NSMatchingReportCompletion range:NSMakeRange(0, adjustedStem.length)];
    }
    adjustedStem = [adjustedStem stringByReplacingOccurrencesOfString:@"&nbsp; (_)" withString:@"&nbsp;(_)"];
    return adjustedStem;
}

- (BOOL)isAnswerMarkedWithStatus:(NSString *)status{
    return [status isEqualToString:kAnswerMarkedFlag];
}

- (NSArray *)audioCommentsWithRawData:(NSArray<__kindof YXQuestion_Pad_AudioComment *> *)audioComments {
    NSMutableArray *array = [NSMutableArray array];
    [audioComments enumerateObjectsUsingBlock:^(__kindof YXQuestion_Pad_AudioComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAAudioComment *comment = [[QAAudioComment alloc]init];
        comment.url = obj.url;
        comment.duration = obj.length;
        [array addObject:comment];
    }];
    return array;
}

- (NSArray *)knowledgePointsWithRawPoints:(NSArray *)rawPoints{
    NSMutableArray *pointArray = [NSMutableArray array];
    for (YXQuestion_Point *rawPoint in rawPoints) {
        QAKnowledgePoint *point = [self knowledgePointFromRawPoint:rawPoint];
        [pointArray addObject:point];
    }
    return [NSArray arrayWithArray:pointArray];
}

- (QAKnowledgePoint *)knowledgePointFromRawPoint:(YXQuestion_Point *)rawPoint{
    QAKnowledgePoint *point = [[QAKnowledgePoint alloc]init];
    point.knpID = rawPoint.pid;
    point.name = rawPoint.name;
    return point;
}

- (NSArray *)correctAnswersWithRawData:(YXQuestion *)rawData{
    return nil;
}

- (NSMutableArray *)myAnswersWithRawData:(YXQuestion *)rawData{
    return nil;
}

- (NSMutableArray *)noteImagesAnswerWithRawData:(NSArray *)imgArray {
    NSMutableArray *noteImagesArray = [NSMutableArray array];
    for (NSString *url in imgArray) {
        QAImageAnswer *answer = [[QAImageAnswer alloc]init];
        answer.url = url;
        [noteImagesArray addObject:answer];
    }
    return noteImagesArray;
}

- (NSArray *)noteImageURLArray {
    NSMutableArray *noteImageURLArray = [NSMutableArray array];
    for (QAImageAnswer *answer in self.noteImages) {
        [noteImageURLArray addObject:answer.url];
    }
    return noteImageURLArray;
}

- (NSArray *)childQuestionsWithRawDatas:(NSArray *)rawDatas{
    if (rawDatas.count == 0) {
        return nil;
    }
    NSMutableArray *questionArray = [NSMutableArray array];
    for (YXIntelligenceQuestion_PaperTest *rawData in rawDatas) {
        QAQuestion *question = [QAQuestionFactory questionFromRawData:rawData];
        question.wrongQuestionID = self.wrongQuestionID;
        if (question) {
            [questionArray addObject:question];
        }
    }
    return [NSArray arrayWithArray:questionArray];
}

- (BOOL)isSingleQuestion {
    if (self.childQuestions.count == 0) {
        return YES;
    }
    return self.questionType == YXQAItemSolve || self.questionType == YXQAItemCalculate;
}

#pragma mark - 答题状态
- (YXQAAnswerState)answerState{
    return YXAnswerStateUnKnown;
}

#pragma mark - 答题状态文字描述
- (NSString *)answerStateDescription {
    NSString *des = [NSString stringWithFormat:@"正确答案是：%@",[self answerPresentation]];
    NSString *result = nil;
    if ([self answerState] == YXAnswerStateCorrect) {
        result = @"回答正确！";
    }else {
        result = @"回答错误！";
    }
    des = [NSString stringWithFormat:@"%@；%@",des,result];
    return des;
}

#pragma mark - 正确答案描述
- (NSString *)answerPresentation {
    return [self.correctAnswers componentsJoinedByString:@","];
}

#pragma mark - 题目类型的文字描述
- (NSString *)typeString{
    return [QAQuestionTypeMappingTable typeNameForType:self.questionType];
}

#pragma mark - 错题列表题干
- (NSString *)stemForMistake {
    return self.stem;
}

#pragma mark - 答题报告
- (YXAnswersItem_PaperDetail *)questionReport{
    YXAnswersItem_PaperDetail *detail = [self questionDetails];
    NSMutableArray *childArray = [NSMutableArray array];
    for (QAQuestion *question in self.childQuestions) {
        [childArray addObject:[question questionDetails]];
    }
    detail.children = (NSArray<YXAnswersItem_PaperDetail,Optional> *)childArray;
    return detail;
}

- (YXAnswersItem_PaperDetail *)questionDetails{
    YXAnswersItem_PaperDetail *detail = [[YXAnswersItem_PaperDetail alloc]init];
    detail.answer = [self answerForReport];
    detail.costtime = [NSString stringWithFormat:@"%.0f",self.answerDuration];
    detail.status = [self answerStatus];
    detail.qid = self.questionID;
    detail.ptid = self.testID;
    detail.paperDetailId = self.answerDetailID? self.answerDetailID:@"-1";
    detail.qtype = (self.templateType == YXQATemplateSubjective)? @"1":nil;
    return detail;
}

- (NSArray *)answerForReport{
    return nil;
}

- (NSString *)answerStatus{
    YXQAAnswerState state = [self answerState];
    if (state == YXAnswerStateCorrect) {
        return @"0";
    }else if (state == YXAnswerStateWrong){
        return @"1";
    }else if (state == YXAnswerStateAnswered){
        return @"4";
    }else if (state == YXAnswerStateHalfCorrect){
        return @"2";
    }
    else{
        return @"3";
    }
}

#pragma mark - 答案本地保存
- (void)saveAnswer {
    
}

- (void)loadAnswer {
    
}

- (void)clearAnswer {
    
}

- (NSString *)questionKey {
    if (!self.paperID || !self.testID || !self.questionID) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@-%@-%@-%@",[YXUserManager sharedManager].userModel.passport.uid,self.paperID,self.testID,self.questionID];
}

@end
