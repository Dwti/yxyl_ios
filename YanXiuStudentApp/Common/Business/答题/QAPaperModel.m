//
//  QAPaperModel.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAPaperModel.h"

@implementation QAQuestionGroup

@end

@interface QAPaperModel()
@property (nonatomic, strong) NSString *paperStatus; // 2:已提交，1:未提交
@end

@implementation QAPaperModel
+ (QAPaperModel *)modelFromRawData:(YXIntelligenceQuestion *)rawData{
    QAPaperModel *model = [[QAPaperModel alloc]init];
    model.paperType = rawData.ptype;
    model.chapterID = rawData.chapterid;
    model.paperID = rawData.qid;
    model.paperTitle = rawData.name;
    model.paperStatusID = rawData.paperStatus.paperstatusid;
    model.paperCreatingTime = rawData.buildtime.doubleValue;
    model.paperBeginingTime = rawData.paperStatus.begintime.doubleValue;
    model.paperStatus = rawData.paperStatus.status;
    model.paperFinishDate = [NSDate dateWithTimeIntervalSince1970:rawData.paperStatus.endtime.doubleValue/1000];
    model.homeworkEndDate = [NSDate dateWithTimeIntervalSince1970:rawData.endtime.doubleValue/1000];
    model.paperAnswerDuration = rawData.paperStatus.costtime.doubleValue;
    model.canShowHomeworkAnalysis = !rawData.showana.boolValue;
    model.checked = rawData.paperStatus.checkStatus.boolValue;
    model.gradeID = rawData.gradeid;
    model.questions = [self questionsWithRawData:rawData];
    
    [self addQuestionPositionsForModel:model];
    
    return model;
}

+ (NSArray *)questionsWithRawData:(YXIntelligenceQuestion *)rawData{
    NSMutableArray *questionArray = [NSMutableArray array];
    for (YXIntelligenceQuestion_PaperTest *test in rawData.paperTest) {
        QAQuestion *question = [QAQuestionFactory questionFromRawData:test];
        if (question) {
            [questionArray addObject:question];
        }
    }
    return questionArray;
}

+ (void)addQuestionPositionsForModel:(QAPaperModel *)model{
    NSInteger total = [self totalQuestionNumberWithModel:model];
    model.totalQuestionNumber = total;
    NSInteger oriIndex = 0;
    for (NSInteger firstLevelIndex=0; firstLevelIndex<model.questions.count; firstLevelIndex++) {
        QAQuestion *question = model.questions[firstLevelIndex];
        if (question.childQuestions.count == 0) {
            QAQuestionPosition *position = [[QAQuestionPosition alloc]init];
            position.firstLevelIndex = firstLevelIndex;
            position.secondLevelIndex = 0;
            position.indexString = [self indexStringWithIndex:oriIndex total:total];
            position.indexDetailString = [NSString stringWithFormat:@"%@",@(oriIndex+1)];
            question.position = position;
            oriIndex++;
        }else{
            QAQuestionPosition *position = [[QAQuestionPosition alloc]init];
            position.firstLevelIndex = firstLevelIndex;
            question.position = position;
            if (question.questionType == YXQAItemSolve || question.questionType == YXQAItemCalculate) {
                position.indexString = [self indexStringWithIndex:oriIndex total:total];
                for (NSInteger secondLevelIndex=0; secondLevelIndex<question.childQuestions.count; secondLevelIndex++) {
                    QAQuestion *childQuestion = question.childQuestions[secondLevelIndex];
                    QAQuestionPosition *position = [[QAQuestionPosition alloc]init];
                    position.firstLevelIndex = firstLevelIndex;
                    position.secondLevelIndex = secondLevelIndex;
                    position.indexString = [self indexStringWithIndex:secondLevelIndex total:question.childQuestions.count];
                    position.indexDetailString = [NSString stringWithFormat:@"%@-%@",@(oriIndex+1),@(secondLevelIndex+1)];
                    childQuestion.position = position;
                }
                oriIndex++;
            }else {
                for (NSInteger secondLevelIndex=0; secondLevelIndex<question.childQuestions.count; secondLevelIndex++) {
                    QAQuestion *childQuestion = question.childQuestions[secondLevelIndex];
                    QAQuestionPosition *position = [[QAQuestionPosition alloc]init];
                    position.firstLevelIndex = firstLevelIndex;
                    position.secondLevelIndex = secondLevelIndex;
                    position.indexString = [self indexStringWithIndex:oriIndex total:total];
                    position.indexDetailString = [NSString stringWithFormat:@"%@",@(oriIndex+1)];
                    childQuestion.position = position;
                    oriIndex++;
                }
            }
        }
    }
}

+ (NSInteger)totalQuestionNumberWithModel:(QAPaperModel *)model {
    NSInteger total = 0;
    for (NSInteger firstLevelIndex=0; firstLevelIndex<model.questions.count; firstLevelIndex++) {
        QAQuestion *question = model.questions[firstLevelIndex];
        if (question.childQuestions.count == 0) {
            total++;
        }else {
            if (question.questionType == YXQAItemSolve || question.questionType == YXQAItemCalculate) {
                total++;
            }else {
                total += question.childQuestions.count;
            }
        }
    }
    return total;
}

+ (NSString *)indexStringWithIndex:(NSInteger)index total:(NSInteger)total {
    return [NSString stringWithFormat:@"%@ / %@",@(index+1),@(total)];
}

#pragma mark - 答题报告
- (NSString *)paperReportStringWithLastBeginDate:(NSDate *)beginDate completeStatus:(BOOL)completed{
    YXAnswersItem *answerItem = [[YXAnswersItem alloc]init];
    answerItem.chapterId = self.chapterID;
    answerItem.ptype = self.paperType;
    answerItem.paperStatus = [self paperStatusWithLastBeginDate:beginDate completeStatus:completed];
    answerItem.paperDetails = (NSArray<YXAnswersItem_PaperDetail, Optional> *)[self questionsReport];
    
    NSString *jsonString = [answerItem toJSONString];
    return jsonString;
}

- (YXAnswersItem_PaperStatus *)paperStatusWithLastBeginDate:(NSDate *)beginDate completeStatus:(BOOL)completed{
    YXAnswersItem_PaperStatus *paperStatus = [[YXAnswersItem_PaperStatus alloc]init];
    paperStatus.begintime = [self paperBeginTimeStringWithLastBeginDate:beginDate];
    paperStatus.costtime = [self paperCostTimeString];
    paperStatus.endtime = [self paperEndTimeString];
    paperStatus.ppid = self.paperID;
    paperStatus.tid = @"0";
    paperStatus.uid = [YXUserManager sharedManager].userModel.passport.uid;
    paperStatus.status = [self paperCompleteStatusStringWithStatus:completed];
    paperStatus.paperStatusId = [self paperStatusIDString];
    return paperStatus;
}

- (NSString *)paperBeginTimeStringWithLastBeginDate:(NSDate *)lastDate{
    if (self.paperBeginingTime == 0) {
        self.paperBeginingTime = [lastDate timeIntervalSince1970]*1000;
    }
    return [NSString stringWithFormat:@"%.0f",self.paperBeginingTime];
}

- (NSString *)paperCostTimeString{
    return [NSString stringWithFormat:@"%.0f",self.paperAnswerDuration];
}

- (NSString *)paperEndTimeString{
    return [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
}

- (NSString *)paperCompleteStatusStringWithStatus:(BOOL)completed{
    if (completed) {
        return @"2";
    }
    return @"1";
}

- (NSString *)paperStatusIDString{
    if (self.paperStatusID) {
        return self.paperStatusID;
    }
    return @"-1";
}

- (NSArray *)questionsReport{
    NSMutableArray *reportArray = [NSMutableArray array];
    for (QAQuestion *question in self.questions) {
        [reportArray addObject:[question questionReport]];
    }
    return reportArray;
}

- (BOOL)isPaperSubmitted {
    return [self.paperStatus isEqualToString:@"2"];
}

#pragma mark - Utils
- (NSArray *)allQuestions{
    NSMutableArray *qArray = [NSMutableArray array];
    for (QAQuestion *q in self.questions) {
        if (q.childQuestions.count > 0) {
            [qArray addObjectsFromArray:q.childQuestions];
        }else{
            [qArray addObject:q];
        }
    }
    return qArray;
}

- (CGFloat)correctRate{
    CGFloat userScore = 0.f;
    CGFloat totalScore = 0.f;
    NSArray *questions = [self allQuestions];
    for (QAQuestion *q in questions) {
        if (q.templateType == YXQATemplateSubjective) {
            if (q.isMarked) {
                totalScore += 1.f;
                userScore += [self userScoreForSubjectiveQuestion:q];
            }
        }else{
            totalScore += 1.f;
            userScore += [self userScoreForObjectiveQuestion:q];
        }
    }
    if (totalScore == 0.f) {
        return 0.f;
    }else{
        return userScore/totalScore;
    }
}

- (CGFloat)userScoreForSubjectiveQuestion:(QAQuestion *)question{
    if (question.score>0 && question.score<kFullMarkScore) {
        return 0.5f;
    }else if (question.score == kFullMarkScore){
        return 1.f;
    }
    return 0.f;
}

- (CGFloat)userScoreForObjectiveQuestion:(QAQuestion *)question{
    YXQAAnswerState state = [question answerState];
    if (state == YXAnswerStateCorrect) {
        return 1.f;
    }
    return 0.f;
}

- (NSArray *)questionGroups{
    // 听力（听音选择、听力选择、听音判断、听音连线、听音排序、听音填空、听力填空）、单选题、多选题、判断题、连线题、归类题、排序题、完型填空、阅读理解、填空题、改错、翻译、计算题、解答题、问答题、材料阅读
    NSMutableArray *allGroups = [NSMutableArray array];
    for (int i=0; i<16; i++) {
        QAQuestionGroup *group = [[QAQuestionGroup alloc]init];
        group.questions = [NSMutableArray array];
        [allGroups addObject:group];
    }
    NSDictionary *mappingDic = @{@"1":allGroups[1],
                                 @"2":allGroups[2],
                                 @"3":allGroups[9],
                                 @"4":allGroups[3],
                                 @"5":allGroups[15],
                                 @"6":allGroups[14],
                                 @"7":allGroups[4],
                                 @"8":allGroups[12],
                                 @"9":allGroups[0],
                                 @"10":allGroups[0],
                                 @"11":allGroups[0],
                                 @"12":allGroups[0],
                                 @"13":allGroups[5],
                                 @"14":allGroups[8],
                                 @"15":allGroups[7],
                                 @"16":allGroups[11],
                                 @"17":allGroups[10],
                                 @"18":allGroups[0],
                                 @"19":allGroups[0],
                                 @"20":allGroups[6],
                                 @"21":allGroups[0],
                                 @"22":allGroups[13]};
    for (QAQuestion *question in self.questions) {
        NSString *key = [NSString stringWithFormat:@"%@",@(question.questionType)];
        QAQuestionGroup *group = [mappingDic valueForKey:key];
        group.name = [question typeString];
        if (question.childQuestions.count == 0) {
            [group.questions addObject:question];
        }else{
            [group.questions addObjectsFromArray:question.childQuestions];
        }
    }
    
    NSMutableArray *groupArray = [NSMutableArray array];
    for (QAQuestionGroup *group in allGroups) {
        if (group.questions.count > 0) {
            [groupArray addObject:group];
        }
    }
    return groupArray;
}

#pragma mark - 错题
+ (void)resetIndexStringWithModel:(QAPaperModel *)model total:(NSInteger)total {
    [model.questions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAQuestion *question = obj;
        QAQuestionPosition *position = [[QAQuestionPosition alloc]init];
        position.indexString = [self indexStringWithIndex:idx total:total];
        position.indexDetailString = [self indexStringWithIndex:idx total:total];
        question.position = position;
        
        if (question.childQuestions.count != 0) {
            for (NSInteger index=0; index<question.childQuestions.count; index++) {
                QAQuestion *childQuestion = question.childQuestions[index];
                QAQuestionPosition *position = [[QAQuestionPosition alloc]init];
                position.indexString = @"";
                position.indexDetailString = [NSString stringWithFormat:@"%@",@(index + 1)];
                childQuestion.position = position;
            }
        }
    }];
}

+ (void)updateQuestionPositionWithQuestion:(QAQuestion *)question index:(NSInteger)index total:(NSInteger)total {
    QAQuestionPosition *position = [[QAQuestionPosition alloc]init];
    position.indexString = [self indexStringWithIndex:index total:total];
    position.indexDetailString = [self indexStringWithIndex:index total:total];
    position.firstLevelIndex = index;
    question.position = position;
    
    if (question.childQuestions.count != 0) {
        for (NSInteger index=0; index<question.childQuestions.count; index++) {
            QAQuestion *childQuestion = question.childQuestions[index];
            QAQuestionPosition *position = [[QAQuestionPosition alloc]init];
            position.indexString = @"";
            position.indexDetailString = [NSString stringWithFormat:@"%@",@(index + 1)];
            childQuestion.position = position;
        }
    }
}

#pragma mark - 错题重做
- (void)updateToWholeModelWithQuestionTotalCount:(NSInteger)total currentOriIndex:(NSInteger)index{
    NSMutableArray *qArray = [NSMutableArray arrayWithArray:self.questions];
    // 填充前面
    for (NSInteger i=0; i<index; i++) {
        QAQuestion *question = [[QAQuestion alloc]init];
        question.templateType = YXQATemplateUnknown;
        [qArray insertObject:question atIndex:0];
    }
    // 填充后面
    NSInteger backEmptyCount = total - qArray.count;
    for (NSInteger i=0; i<backEmptyCount; i++) {
        QAQuestion *question = [[QAQuestion alloc]init];
        question.templateType = YXQATemplateUnknown;
        [qArray addObject:question];
    }
    self.questions = qArray;
    [self.questions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAQuestion *question = obj;
        [QAPaperModel updateQuestionPositionWithQuestion:question index:idx total:total];
    }];
}

- (void)replaceQuestions:(NSArray *)questionArray fromIndex:(NSInteger)index {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.questions];
    [array replaceObjectsInRange:NSMakeRange(index, questionArray.count) withObjectsFromArray:questionArray];
    self.questions = array;
    
    NSInteger from = index;
    NSInteger to = index+questionArray.count;
    for (NSInteger i=from; i<to; i++) {
        QAQuestion *question = self.questions[i];
        [QAPaperModel updateQuestionPositionWithQuestion:question index:i total:self.questions.count];
    }
}

- (NSString *)redoReportString {
    __block NSInteger correct = 0;
    __block NSInteger wrong = 0;
    [self.questions enumerateObjectsUsingBlock:^(QAQuestion *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.redoStatus==QARedoStatus_CanDelete || obj.redoStatus==QARedoStatus_AlreadyDelete) {
            if ([obj answerState] == YXAnswerStateCorrect) {
                correct++;
            }else {
                wrong++;
            }
        }
    }];
    return [NSString stringWithFormat:@"共作答：%@题\n\n答对：%@题\n\n答错：%@题",@(correct+wrong),@(correct),@(wrong)];
}

@end
