//
//  MistakeQuestionManager.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/8.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetSubjectMistakeRequest.h"
#import "YXDelMistakeRequest.h"
#import "YXErrorsRequest.h"
#import "YXIntelligenceQuestionListItem.h"
#import "MistakeRedoNumRequest.h"
#import "SaveMistakeNoteRequest.h"

extern NSString *const kDeleteMistakeSuccessNotification;
extern const NSInteger kRedoPageSize;

typedef void(^SubjectMistakeBlock) (GetSubjectMistakeRequestItem *item, NSError *error);
typedef void(^DeleteMistakeBlock) (NSError *error);
typedef void(^MistakeListBlock) (YXIntelligenceQuestionListItem *item, NSError *error);
typedef void(^MistakeRedoNumBlock) (MistakeRedoNumItem *item, NSError *error);
typedef void(^MistakeRedoNoteBlock) (MistakeRedoNoteItem *item, NSError *error);

@interface MistakeQuestionManager : NSObject
+ (instancetype)sharedInstance;

- (void)requestSubjectMistakeWithCompleteBlock:(SubjectMistakeBlock)completeBlock;
- (void)deleteMistakeQuestion:(QAQuestion *)question completeBlock:(DeleteMistakeBlock)completeBlock;
- (void)requestMistakeListWithsubjectID:(NSString *)subjectID page:(NSString *)page currentID:(NSString *)currentID completeBlock:(MistakeListBlock)completeBlock;
- (void)requestMistakeRedoNumWithSubjectId:(NSString *)subjectID completeBlock: (MistakeRedoNumBlock )completeBlock;
- (void)saveMistakeRedoNoteWithQuestion:(QAQuestion *)question completeBlock:(MistakeRedoNoteBlock)completeBlock;
- (void)requestMistakeRedoFirstWithSubjectID:(NSString *)subjectID completeBlock:(void(^)(QAPaperModel *model, NSError *error))completeBlock;
- (void)requestMistakeRedoPageWithSubjectID:(NSString *)subjectID page:(NSString *)page completeBlock:(void(^)(QAPaperModel *model, NSError *error))completeBlock;
- (void)deleteMistakeRedoQuestion:(QAQuestion *)question subjectId:(NSString *)subjectId deletedIDs:(NSArray*)deletedIDs completeBlock:(DeleteMistakeBlock)completeBlock;
@end
