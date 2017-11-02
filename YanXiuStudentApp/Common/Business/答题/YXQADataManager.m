//
//  YXQADataManager.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/18.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQADataManager.h"
#import "YXSubmitQuestionRequest.h"
#import "YXGetQuestionReportRequest.h"
#import "PaperAnswerDurationEntity+CoreDataProperties.h"
#import "PaperAnsweredNumEntity+CoreDataClass.h"
#import "PaperHasShowVideoEntity+CoreDataClass.h"
#import "BCPaperAnswerStateEntity+CoreDataClass.h"

NSString * const kSubmitQuestionSuccessPaperIDKey = @"kSubmitQuestionSuccessPaperIDKey";
NSString * const kSubmitQuestionSuccessPaperCorrectRateKey = @"kSubmitQuestionSuccessPaperCorrectRateKey";

@interface YXQADataManager()
@property (nonatomic, strong) YXSubmitQuestionRequest *submitRequest;
@property (nonatomic, strong) YXGetQuestionReportRequest *reportRequest;
@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) YXQARequestParams *requestParams;
@property (nonatomic, copy) void(^submitCompleteBlock)(NSError *error, QAPaperModel *reportModel);
@end

@implementation YXQADataManager

+ (instancetype)sharedInstance
{
    static YXQADataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YXQADataManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Setter & Getter
- (void)setQaHasEnteredBefore:(BOOL)qaHasEnteredBefore{
    [[NSUserDefaults standardUserDefaults]setBool:qaHasEnteredBefore forKey:@"kQAHasEnteredBeforeKey"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (BOOL)qaHasEnteredBefore{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"kQAHasEnteredBeforeKey"];
}

- (BOOL)qaHasEnteredComplex {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kQAHasEnteredComplex"];
}

- (void)setQaHasEnteredComplex:(BOOL)qaHasEnteredComplex {
    [[NSUserDefaults standardUserDefaults] setBool:qaHasEnteredComplex forKey:@"kQAHasEnteredComplex"];
}

- (BOOL)qaHasEnteredClassify {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kQAHasEnteredClassify"];
}

- (void)setQaHasEnteredClassify:(BOOL)qaHasEnteredClassify {
    [[NSUserDefaults standardUserDefaults] setBool:qaHasEnteredClassify forKey:@"kQAHasEnteredClassify"];
}


- (void)setHasDoExerciseToday:(BOOL)hasDoExerciseToday{
    if (!hasDoExerciseToday) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:[YXUserManager sharedManager].userModel.uid];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return;
    }
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = @"yyyyMMdd";
    NSString *date = [formater stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults]setValue:date forKey:[YXUserManager sharedManager].userModel.uid];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (BOOL)hasDoExerciseToday{
    NSString *uid = [YXUserManager sharedManager].userModel.uid;
    if (uid.length == 0) {
        return NO;
    }
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = @"yyyyMMdd";
    NSString *date = [formater stringFromDate:[NSDate date]];
    NSString *savedDate = [[NSUserDefaults standardUserDefaults] valueForKey:uid];
    if ([savedDate isEqualToString:date]) {
        return YES;
    }
    return NO;
}

#pragma mark - 提交试卷
// 提交试卷，共分三步走，1、提交主观题的图片获取url 2、提交试卷内容 3、 获取答题报告
- (void)submitPaperWithModel:(QAPaperModel *)model
                   beginDate:(NSDate *)beginDate
               requestParams:(YXQARequestParams *)requestParams
               completeBlock:(void(^)(NSError *error, QAPaperModel *reportModel))completeBlock{
    
    self.model = model;
    self.beginDate = beginDate;
    self.requestParams = requestParams;
    self.submitCompleteBlock = completeBlock;
    [self submitImageAndGetUrl];
}

// 第一步：提交主观题的图片获取url
- (void)submitImageAndGetUrl {
    [[YXQAUploadImageManager sharedInstance] stopUploadImage];
    @weakify(self);
    [[YXQAUploadImageManager sharedInstance] uploadImageInModel:self.model completeBlock:^(NSError *error) {
        @strongify(self);
        if (error) {
            self.submitCompleteBlock(error,nil);
        }else{
            [self submitPaper];
        }
    }];
}

// 第二步：提交试卷内容
- (void)submitPaper{
    NSString *answerStr = [self.model paperReportStringWithLastBeginDate:self.beginDate completeStatus:YES];
    
    [self.submitRequest stopRequest];
    self.submitRequest = [[YXSubmitQuestionRequest alloc]init];
    self.submitRequest.answers = answerStr;
    @weakify(self)
    [self.submitRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self)
        if (error) {
            if (error.code == 66) {
                [[NSNotificationCenter defaultCenter] postNotificationName:YXSubmitQuestionPaperNotExistNotification object:nil];
            }else {
                self.submitCompleteBlock(error, nil);
            }
        }else{
            [self getReport];
            //答题提交成功发送通知，刷新界面
            NSDictionary *infoDic = @{kSubmitQuestionSuccessPaperCorrectRateKey:@([self.model correctRate]),
                                      kSubmitQuestionSuccessPaperIDKey:self.model.paperID
                                      };
            [[NSNotificationCenter defaultCenter]postNotificationName:YXSubmitQuestionSuccessNotification object:nil userInfo:infoDic];
        }
    }];
}

// 第三步：获取答题报告
- (void)getReport{
    [self.reportRequest stopRequest];
    self.reportRequest = [[YXGetQuestionReportRequest alloc]init];
    self.reportRequest.ppid = self.model.paperID;
    self.reportRequest.flag = @"1";
    @weakify(self)
    [self.reportRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self)
        if (error) {
            self.submitCompleteBlock(error, nil);
        }else{
            QAPaperModel *reportModel = nil;
            YXIntelligenceQuestionListItem *item = (YXIntelligenceQuestionListItem *)retItem;
            if (item.data.count > 0) {
                YXIntelligenceQuestion *question = item.data[0];
                reportModel = [QAPaperModel modelFromRawData:question];
            }
            self.submitCompleteBlock(nil, reportModel);
        }
    }];
}

// 停止提交
- (void)stopSubmitPaper{
    [[YXQAUploadImageManager sharedInstance] stopUploadImage];
    [self.submitRequest stopRequest];
    [self.reportRequest stopRequest];
}

#pragma mark - 保存试卷
- (void)savePaperToHistoryWithModel:(QAPaperModel *)model beginDate:(NSDate *)beginDate completeBlock:(void(^)(NSError *error))completeBlock{
    [[YXQAUploadImageManager sharedInstance] stopUploadImage];
    @weakify(self);
    [[YXQAUploadImageManager sharedInstance] uploadImageInModel:model completeBlock:^(NSError *error) {
        @strongify(self);
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        NSString *answerStr = [model paperReportStringWithLastBeginDate:beginDate completeStatus:NO];
        [self saveAnswerReport:answerStr completeBlock:completeBlock];
    }];
}

- (void)saveAnswerReport:(NSString *)answers completeBlock:(void(^)(NSError *error))completeBlock {
    [self.submitRequest stopRequest];
    self.submitRequest = [[YXSubmitQuestionRequest alloc]init];
    self.submitRequest.answers = answers;
    [self.submitRequest startRequestWithRetClass:nil andCompleteBlock:^(id retItem, NSError *error) {
        BLOCK_EXEC(completeBlock,nil);
        [[NSNotificationCenter defaultCenter] postNotificationName:YXSavePaperSuccessNotification object:nil];
    }];
}

- (void)setUploadImageBlock:(UploadImageProgressBlock)block {
    [[YXQAUploadImageManager sharedInstance] setUploadImageBlock:block];
}

#pragma mark - 本地保存答题时间
- (void)savePaperDurationWithPaperID:(NSString *)paperID duration:(NSTimeInterval)duration {
    if (isEmpty(paperID)) {
        return;
    }
    WEAK_SELF
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        STRONG_SELF
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@ AND paperID = %@",[YXUserManager sharedManager].userModel.passport.uid,paperID];
        PaperAnswerDurationEntity *entity = [PaperAnswerDurationEntity MR_findFirstWithPredicate:predicate inContext:localContext];
        if (!entity) {
            entity = [PaperAnswerDurationEntity MR_createEntityInContext:localContext];
            entity.uid = [YXUserManager sharedManager].userModel.passport.uid;
            entity.paperID = paperID;
        }
        entity.duration = @(duration);
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:YXSavePaperSuccessNotification object:nil];
}

- (NSTimeInterval)loadPaperDurationWithPaperID:(NSString *)paperID {
    if (isEmpty(paperID)) {
        return 0;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@ AND paperID = %@",[YXUserManager sharedManager].userModel.passport.uid,paperID];
    PaperAnswerDurationEntity *entity = [PaperAnswerDurationEntity MR_findFirstWithPredicate:predicate];
    if (!entity) {
        return 0;
    }
    return entity.duration.floatValue;
}

- (void)clearPaperDurationWithPaperID:(NSString *)paperID {
    if (isEmpty(paperID)) {
        return;
    }
    WEAK_SELF
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        STRONG_SELF
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@ AND paperID = %@",[YXUserManager sharedManager].userModel.passport.uid,paperID];
        PaperAnswerDurationEntity *entity = [PaperAnswerDurationEntity MR_findFirstWithPredicate:predicate inContext:localContext];
        [entity MR_deleteEntityInContext:localContext];
    }];
}

#pragma mark - 试卷完成题目数量
- (void)savePaperAnsweredQuestionNumWithPaperModel:(QAPaperModel *)model {
    if (isEmpty(model.paperID)) {
        return;
    }
    NSInteger answeredNum = 0;
    for (QAQuestion *question in model.questions) {
        if (question.childQuestions.count == 0) {
            YXQAAnswerState state = [question answerState];
            if (state==YXAnswerStateWrong || state==YXAnswerStateCorrect || state==YXAnswerStateAnswered) {
                answeredNum++;
            }
        }else {
            if ([question isSingleQuestion]) {
                BOOL answered = YES;
                for (QAQuestion *subQ in question.childQuestions) {
                    YXQAAnswerState state = [subQ answerState];
                    if (state==YXAnswerStateNotAnswer || state==YXAnswerStatePartAnswer) {
                        answered = NO;
                        break;
                    }
                }
                if (answered) {
                    answeredNum++;
                }
            }else {
                for (QAQuestion *subQ in question.childQuestions) {
                    YXQAAnswerState state = [subQ answerState];
                    if (state==YXAnswerStateWrong || state==YXAnswerStateCorrect || state==YXAnswerStateAnswered) {
                        answeredNum++;
                    }
                }
            }
        }
    }
    WEAK_SELF
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        STRONG_SELF
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@ AND paperID = %@",[YXUserManager sharedManager].userModel.passport.uid,model.paperID];
        PaperAnsweredNumEntity *entity = [PaperAnsweredNumEntity MR_findFirstWithPredicate:predicate inContext:localContext];
        if (!entity) {
            entity = [PaperAnsweredNumEntity MR_createEntityInContext:localContext];
            entity.uid = [YXUserManager sharedManager].userModel.passport.uid;
            entity.paperID = model.paperID;
        }
        entity.answeredNum = @(answeredNum);
    }];
}

- (NSInteger)loadPaperAnsweredQuestionNumWithPaperID:(NSString *)paperID {
    if (isEmpty(paperID)) {
        return 0;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@ AND paperID = %@",[YXUserManager sharedManager].userModel.passport.uid,paperID];
    PaperAnsweredNumEntity *entity = [PaperAnsweredNumEntity MR_findFirstWithPredicate:predicate];
    if (!entity) {
        return 0;
    }
    return entity.answeredNum.integerValue;
}

- (void)clearPaperAnsweredQuestionNumWithPaperID:(NSString *)paperID {
    if (isEmpty(paperID)) {
        return;
    }
    WEAK_SELF
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        STRONG_SELF
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@ AND paperID = %@",[YXUserManager sharedManager].userModel.passport.uid,paperID];
        PaperAnsweredNumEntity *entity = [PaperAnsweredNumEntity MR_findFirstWithPredicate:predicate inContext:localContext];
        [entity MR_deleteEntityInContext:localContext];
    }];
}

#pragma mark - BC资源 相关
//试卷是否显示过视频提示页
- (void)savePaperHasShowVideoWithPaperID:(NSString *)paperID hasShowVideo:(NSString *)hasShowVideo {
    if (isEmpty(paperID)) {
        return ;
    }
    WEAK_SELF
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        STRONG_SELF
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@ AND paperID = %@",[YXUserManager sharedManager].userModel.passport.uid,paperID];
        PaperHasShowVideoEntity *entity = [PaperHasShowVideoEntity MR_findFirstWithPredicate:predicate inContext:localContext];
        if (!entity) {
            entity = [PaperHasShowVideoEntity MR_createEntityInContext:localContext];
            entity.uid = [YXUserManager sharedManager].userModel.passport.uid;
            entity.paperID = paperID;
        }
        entity.hasShowVideo = hasShowVideo;
    }];
}

- (NSString *)loadPaperHasShowVideoWithPaperID:(NSString *)paperID {
    if (isEmpty(paperID)) {
        return @"0";
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@ AND paperID = %@",[YXUserManager sharedManager].userModel.passport.uid,paperID];
    PaperHasShowVideoEntity *entity = [PaperHasShowVideoEntity MR_findFirstWithPredicate:predicate];
    if (!entity) {
        return @"0";
    }
    return entity.hasShowVideo;
}
//试卷的作答状态
- (void)savePaperAnswerStateWithPaperID:(NSString *)paperID answerState:(NSString *)answerState{
    if (isEmpty(paperID)) {
        return ;
    }
    WEAK_SELF
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        STRONG_SELF
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@ AND paperID = %@",[YXUserManager sharedManager].userModel.passport.uid,paperID];
        BCPaperAnswerStateEntity *entity = [BCPaperAnswerStateEntity MR_findFirstWithPredicate:predicate inContext:localContext];
        if (!entity) {
            entity = [BCPaperAnswerStateEntity MR_createEntityInContext:localContext];
            entity.uid = [YXUserManager sharedManager].userModel.passport.uid;
            entity.paperID = paperID;
        }
        entity.answerState = answerState;
    }];
}

- (NSString *)loadPaperAnswerStateWithPaperID:(NSString *)paperID {
    if (isEmpty(paperID)) {
        return @"0";
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@ AND paperID = %@",[YXUserManager sharedManager].userModel.passport.uid,paperID];
    BCPaperAnswerStateEntity *entity = [BCPaperAnswerStateEntity MR_findFirstWithPredicate:predicate];
    if (!entity) {
        return @"0";
    }
    return entity.answerState;
}
@end
