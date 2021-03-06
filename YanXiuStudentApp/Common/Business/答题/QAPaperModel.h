//
//  QAPaperModel.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAQuestionGroup : NSObject  // 用于报告页的分组展示
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *questions;
@end

@interface QAPaperModel : NSObject
@property (nonatomic, copy) NSString *paperID;
@property (nonatomic, copy) NSString *paperType;
@property (nonatomic, copy) NSString *paperTitle;
@property (nonatomic, copy) NSString *paperStatusID;

@property (nonatomic, assign) NSTimeInterval paperCreatingTime;
@property (nonatomic, assign) NSTimeInterval paperBeginingTime;
@property (nonatomic, assign) NSTimeInterval paperAnswerDuration;
@property (nonatomic, assign) CGFloat paperCorrectRate;

@property (nonatomic, strong) NSDate *homeworkEndDate;
@property (nonatomic, strong) NSDate *paperFinishDate;

@property (nonatomic, copy) NSString *gradeID;
@property (nonatomic, copy) NSString *chapterID;

@property (nonatomic, assign) BOOL checked; // 是否批改，YES已批改，NO未批改
@property (nonatomic, assign) BOOL canShowHomeworkAnalysis; //用于作业，未到作业截止日之前不可以显示解析，以免其它还未作答的同学知道答案
@property (nonatomic, assign) NSInteger totalQuestionNumber; // 题目总数，按小题计算

@property (nonatomic, strong) NSArray<QAQuestion *> *questions; // element type is QAQuestion


//仅用于BC资源
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *videoUrl; //话题视频url;
@property (nonatomic, copy) NSString *videoSize; //视频大小 （单位B，须按pm要求换算)
@property (nonatomic, copy) NSString *hasShowPrompt;//是否已经显示过视频提示页

+ (QAPaperModel *)modelFromRawData:(YXIntelligenceQuestion *)rawData;
+ (void)resetIndexStringWithModel:(QAPaperModel *)model total:(NSInteger)total; // 用于错题

- (NSString *)paperReportStringWithLastBeginDate:(NSDate *)beginDate completeStatus:(BOOL)completed;
- (BOOL)isPaperSubmitted;
// Utils
- (NSArray *)allQuestions;
- (NSArray *)allLogicQuestions;
- (CGFloat)correctRate;
- (NSArray *)questionGroups; // element type is QAQuestionGroup
//错题重做
- (void)updateToWholeModelWithQuestionTotalCount:(NSInteger)total currentOriIndex:(NSInteger)index;
- (void)replaceQuestions:(NSArray *)questionArray fromIndex:(NSInteger)index;
- (NSString *)redoReportString;

@end
