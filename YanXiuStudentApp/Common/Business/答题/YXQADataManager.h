//
//  YXQADataManager.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/18.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXQAUploadImageManager.h"

static NSString *const YXSubmitQuestionSuccessNotification = @"kYXSubmitQuestionSuccessNotification";
static NSString *const YXFavorChangedNotification = @"kYXFavorChangedNotification";
static NSString *const YXSavePaperSuccessNotification = @"YXSavePaperSuccessNotification";

@interface YXQADataManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL qaHasEnteredBefore; // 是否第一次进入答题
@property (nonatomic, assign) BOOL hasDoExerciseToday; // 当天都否做过练习

@property (nonatomic, assign) BOOL qaHasEnteredClassify; // 是否第一次进入归类题
@property (nonatomic, assign) BOOL qaHasEnteredComplex;  // 是否第一次进入复合体


/**
 *  提交试卷
 *
 *  @param model         试卷的model
 *  @param beginDate     答题开始时间
 *  @param requestParams 试卷的请求参数
 *  @param completeBlock 完成时的回调
 */
- (void)submitPaperWithModel:(QAPaperModel *)model
                   beginDate:(NSDate *)beginDate
               requestParams:(YXQARequestParams *)requestParams
               completeBlock:(void(^)(NSError *error, QAPaperModel *reportModel))completeBlock;

/**
 *  停止提交试卷
 */
- (void)stopSubmitPaper;

/**
 *  将试卷存入练习历史
 *
 *  @param model     试卷的model
 *  @param beginDate 答题开始时间
 */
- (void)savePaperToHistoryWithModel:(QAPaperModel *)model beginDate:(NSDate *)beginDate completeBlock:(void(^)(NSError *error))completeBlock;


- (void)setUploadImageBlock:(UploadImageProgressBlock)block;



@end
