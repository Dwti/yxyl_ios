//
//  MistakeQuestionManager.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/8.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "MistakeQuestionManager.h"
#import "MistakeRedoUploadImageManager.h"
#import "SaveMistakeNoteRequest.h"
#import "MistakeRedoFirstRequest.h"
#import "MistakeRedoPageRequest.h"
#import "MistakeRedoFinishRequest.h"
#import "GlobalUtils.h"

NSString *const kDeleteMistakeSuccessNotification = @"kSubjectSaveEditionInfoSuccessNotification";
const NSInteger kRedoPageSize = 10;

@interface MistakeQuestionManager ()
@property (nonatomic, strong) GetSubjectMistakeRequest *subjectRequest;
@property (nonatomic, strong) YXDelMistakeRequest *delRequest;
@property (nonatomic, strong) YXErrorsRequest *mistakeListRequest;
@property (nonatomic, strong) MistakeRedoNumRequest *mistakeRedoNumRequest;
@property (nonatomic, strong) SaveMistakeNoteRequest *saveMistakeNoteRequest;
@property (nonatomic, strong) MistakeRedoFirstRequest *redoFirstRequest;
@property (nonatomic, strong) MistakeRedoPageRequest *redoPageRequest;
@property (nonatomic, strong) MistakeRedoFinishRequest *finishRequest;
@end

@implementation MistakeQuestionManager
+ (instancetype)sharedInstance {
    static MistakeQuestionManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MistakeQuestionManager alloc] init];
    });
    return sharedInstance;
}

- (void)requestSubjectMistakeWithCompleteBlock:(SubjectMistakeBlock)completeBlock {
    [self.subjectRequest stopRequest];
    self.subjectRequest = [[GetSubjectMistakeRequest alloc]init];
    self.subjectRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
    [self.subjectRequest startRequestWithRetClass:[GetSubjectMistakeRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        if (error && error.code != 67) { // 67表示无内容，而应该为0，fuck
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}

- (void)deleteMistakeQuestion:(QAQuestion *)question completeBlock:(DeleteMistakeBlock)completeBlock {
    [self.delRequest stopRequest];
    self.delRequest = [[YXDelMistakeRequest alloc]init];
    self.delRequest.questionId = question.questionID;
    [self.delRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        if (error && error.code != 69) { // 69表示成功，fuck
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        BLOCK_EXEC(completeBlock,nil);
        [[NSNotificationCenter defaultCenter]postNotificationName:kDeleteMistakeSuccessNotification object:@[question.wrongQuestionID]];
    }];
}

- (void)deleteMistakeRedoQuestion:(QAQuestion *)question subjectId:(NSString *)subjectId deletedIDs:(NSArray*)deletedIDs completeBlock:(DeleteMistakeBlock)completeBlock {
    [self.finishRequest stopRequest];
    self.finishRequest = [[MistakeRedoFinishRequest alloc]init];
    self.finishRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
    self.finishRequest.subjectId = subjectId;
    self.finishRequest.lastWqid = question.wrongQuestionID;
    self.finishRequest.lastWqnumber = [NSString stringWithFormat:@"%@",@(question.wrongQuestionIndex)];
    self.finishRequest.deleteWqidList = [deletedIDs componentsJoinedByString:@","];
   
    [self.finishRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        BLOCK_EXEC(completeBlock,nil);
        [[NSNotificationCenter defaultCenter]postNotificationName:kDeleteMistakeSuccessNotification object:deletedIDs];
    }];

}

- (void)requestMistakeListWithsubjectID:(NSString *)subjectID page:(NSString *)page currentID:(NSString *)currentID completeBlock:(MistakeListBlock)completeBlock {
    [self.mistakeListRequest stopRequest];
    self.mistakeListRequest = [[YXErrorsRequest alloc]init];
    self.mistakeListRequest.subjectId = subjectID;
    self.mistakeListRequest.pageSize = @"10";
    self.mistakeListRequest.currentPage = page;
    self.mistakeListRequest.currentId = currentID;
    self.mistakeListRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
    [self.mistakeListRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        BLOCK_EXEC(completeBlock,retItem,error);
    }];
}

- (void)requestMistakeRedoNumWithSubjectId:(NSString *)subjectID completeBlock: (MistakeRedoNumBlock)completeBlock {
    [self.mistakeRedoNumRequest stopRequest];
    self.mistakeRedoNumRequest = [[MistakeRedoNumRequest alloc] init];
    self.mistakeRedoNumRequest.subjectId = subjectID;
    self.mistakeRedoNumRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
    [self.mistakeRedoNumRequest startRequestWithRetClass:[MistakeRedoNumItem class] andCompleteBlock:^(id retItem, NSError *error) {
        BLOCK_EXEC(completeBlock, retItem, error);
    }];
}

- (void)saveMistakeRedoNoteWithQuestion:(QAQuestion *)question completeBlock:(MistakeRedoNoteBlock)completeBlock {
    if (![self isNetworkReachable]) {
        NSError *error = [[NSError alloc] init];
        error = [NSError errorWithDomain:NetworkRequestErrorDomain code:ASIConnectionFailureErrorType userInfo:@{NSLocalizedDescriptionKey:@"网络未连接，请检查后重试"}];
        BLOCK_EXEC(completeBlock, nil, error);
        return;
    }
    
    [[MistakeRedoUploadImageManager sharedInstance] stopUploadImage];
    [[MistakeRedoUploadImageManager sharedInstance] uploadImageInQuestion:question completeBlock:^(NSError *error) {
        if (error) {
            if (![self isNetworkReachable]) {
                error = [NSError errorWithDomain:NetworkRequestErrorDomain code:ASIConnectionFailureErrorType userInfo:@{NSLocalizedDescriptionKey:@"保存失败，请检查网络后重试"}];
            }
            BLOCK_EXEC(completeBlock, nil, error);
            return;
        }
        
        [self.saveMistakeNoteRequest stopRequest];
        MistakeNote *note = [[MistakeNote alloc] init];
        note.qid = question.questionID;
        note.text =  question.noteText;
        note.images = [question noteImageURLArray];
        NSString *noteJsonStr = [note toJSONString];
        self.saveMistakeNoteRequest = [[SaveMistakeNoteRequest alloc] init];
        self.saveMistakeNoteRequest.wqid = question.wrongQuestionID;
        self.saveMistakeNoteRequest.note = noteJsonStr;
            
        [self.saveMistakeNoteRequest startRequestWithRetClass:[MistakeRedoNoteItem class] andCompleteBlock:^(id retItem, NSError *error) {
            if (error) {
                if (![self isNetworkReachable]) {
                    error = [NSError errorWithDomain:NetworkRequestErrorDomain code:ASIConnectionFailureErrorType userInfo:@{NSLocalizedDescriptionKey:@"保存失败，请检查网络后重试"}];
                }
                BLOCK_EXEC(completeBlock, retItem, error);
                return ;
            }
            
            BLOCK_EXEC(completeBlock, retItem, nil);
            [[NSNotificationCenter defaultCenter] postNotificationName:MistakeNoteSaveNotification object:question.questionID];
        }];
    }];
}

- (void)requestMistakeRedoFirstWithSubjectID:(NSString *)subjectID completeBlock:(void(^)(QAPaperModel *model, NSError *error))completeBlock {
    [self.redoFirstRequest stopRequest];
    self.redoFirstRequest = [[MistakeRedoFirstRequest alloc]init];
    self.redoFirstRequest.subjectId = subjectID;
    self.redoFirstRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
    self.redoPageRequest.pageSize = [NSString stringWithFormat:@"%@",@(kRedoPageSize)];
    WEAK_SELF
    [self.redoFirstRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        YXIntelligenceQuestionListItem *item = (YXIntelligenceQuestionListItem *)retItem;
        YXIntelligenceQuestion *intelQuestion = item.data[0];
        for (YXIntelligenceQuestion_PaperTest *pt in intelQuestion.paperTest) {
            [pt clearMyAnswers];
        }
        QAPaperModel *model = [QAPaperModel modelFromRawData:intelQuestion];
        BLOCK_EXEC(completeBlock,model,nil);
    }];
}

- (void)requestMistakeRedoPageWithSubjectID:(NSString *)subjectID page:(NSString *)page completeBlock:(void(^)(QAPaperModel *model, NSError *error))completeBlock {
    [self.redoPageRequest stopRequest];
    self.redoPageRequest = [[MistakeRedoPageRequest alloc]init];
    self.redoPageRequest.subjectId = subjectID;
    self.redoPageRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
    self.redoPageRequest.page = page;
    self.redoPageRequest.pageSize = [NSString stringWithFormat:@"%@",@(kRedoPageSize)];
    WEAK_SELF
    [self.redoPageRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        YXIntelligenceQuestionListItem *item = (YXIntelligenceQuestionListItem *)retItem;
        YXIntelligenceQuestion *intelQuestion = item.data[0];
        for (YXIntelligenceQuestion_PaperTest *pt in intelQuestion.paperTest) {
            [pt clearMyAnswers];
        }
        QAPaperModel *model = [QAPaperModel modelFromRawData:intelQuestion];
        BLOCK_EXEC(completeBlock,model,nil);
    }];
}

@end
