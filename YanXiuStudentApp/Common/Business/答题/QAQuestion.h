//
//  QAQuestion.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXIntelligenceQuestion.h"
#import "YXQADefinitions.h"
#import "YXSubmitQuestionRequest.h"
#import "QuestionAnswerEntity+CoreDataProperties.h"

typedef NS_ENUM(NSUInteger, QARedoStatus) {
    QARedoStatus_Init = 0,
    QARedoStatus_CanSubmit,
    QARedoStatus_CanDelete,
    QARedoStatus_AlreadyDelete
};

@interface QAAudioComment : NSObject
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *duration;
@end

@interface QAQuestionPosition : NSObject
@property (nonatomic, assign) NSInteger firstLevelIndex;
@property (nonatomic, assign) NSInteger secondLevelIndex;
@property (nonatomic, strong) NSString *indexString; // 小题编号，按全部小题编排，解答题算做一个小题，其所属每个小题编号相同
@property (nonatomic, strong) NSString *indexDetailString; // 小题详细编号，解答题小题编号采用x－x形式，其它与小题编号相同
@end

@interface QAKnowledgePoint : NSObject
@property (nonatomic, copy) NSString *knpID;
@property (nonatomic, copy) NSString *name;
@end

@interface QAQuestion : NSObject
- (instancetype)initWithRawData:(YXIntelligenceQuestion_PaperTest *)rawData;

@property (nonatomic, assign) YXQAItemType questionType;
@property (nonatomic, assign) YXQATemplateType templateType;

@property (nonatomic, copy) NSString *testID;
@property (nonatomic, copy) NSString *questionID;
@property (nonatomic, copy) NSString *answerDetailID;
@property (nonatomic, copy) NSString *wrongQuestionID;
@property (nonatomic, copy) NSString *paperID;

@property (nonatomic, copy) NSString *stem;
@property (nonatomic, copy) NSString *audioUrl;
@property (nonatomic, strong) NSArray *options; // element type is NSString
@property (nonatomic, assign) BOOL isFavorite;

@property (nonatomic, strong) NSMutableArray *myAnswers; // element type is set by subclass
@property (nonatomic, strong) NSArray *correctAnswers; // element type is set by subclass

@property (nonatomic, copy) NSString *analysis;
@property (nonatomic, copy) NSString *globalStatis;
@property (nonatomic, copy) NSString *answerCompare;
@property (nonatomic, copy) NSString *difficulty;
@property (nonatomic, strong) NSArray *knowledgePoints; // element type is QAKnowledgePoint

@property (nonatomic, copy) NSString *comment;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, assign) BOOL isMarked;
@property (nonatomic, strong) NSArray<__kindof QAAudioComment *> *audioComments;

@property (nonatomic, assign) NSTimeInterval answerDuration;

@property (nonatomic, strong) QAQuestionPosition *position;

@property (nonatomic, strong) NSArray<__kindof QAQuestion *> *childQuestions;

@property (nonatomic, assign) QARedoStatus redoStatus;
@property (nonatomic, assign) NSInteger wrongQuestionIndex;
@property (nonatomic, assign) BOOL redoCompleted;

@property (nonatomic, strong) NSString *noteText;
@property (nonatomic, strong) NSArray *noteImages; // QAImageAnswer Tyep 

- (NSArray *)correctAnswersWithRawData:(YXQuestion *)rawData; // 需子类实现
- (NSMutableArray *)myAnswersWithRawData:(YXQuestion *)rawData; // 需子类实现

- (YXQAAnswerState)answerState; // 需子类实现
- (NSString *)answerStateDescription; // 作答状态文字描述
- (NSString *)answerPresentation; // 需子类实现
- (NSString *)typeString;
- (NSString *)stemForMistake; // 错题列表的题干
- (BOOL)isSingleQuestion;

- (YXAnswersItem_PaperDetail *)questionReport;
- (NSArray *)answerForReport; // 需子类实现

- (NSArray *)noteImageURLArray;

#pragma mark - 答案本地保存
- (void)saveAnswer;
- (void)loadAnswer;
- (void)clearAnswer;
- (NSString *)questionKey;

@end
