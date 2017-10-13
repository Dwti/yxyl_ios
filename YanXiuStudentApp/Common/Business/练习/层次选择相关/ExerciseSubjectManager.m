//
//  ExerciseSubjectManager.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseSubjectManager.h"
#import "SaveEditionRequest.h"
#import "GetTopicRequest.h"

NSString *const kSubjectSaveEditionInfoSuccessNotification = @"kSubjectSaveEditionInfoSuccessNotification";

@interface ExerciseSubjectManager ()
@property (nonatomic, strong) NSMutableDictionary *subjectDictionary;
@property (nonatomic, strong) GetSubjectRequest *subjectRequest;
@property (nonatomic, strong) GetTopicRequest *topicRequest;

@property (nonatomic, strong) GetEditionRequest *editionRequest;
@property (nonatomic, strong) GetVolumesRequest *getVolumeRequest;
@property (nonatomic, strong) SaveFavVolumeRequest *saveVolumeRequest;

@property (nonatomic, strong) SaveEditionRequest *saveEditionRequest;
@end

@implementation ExerciseSubjectManager

+ (instancetype)sharedInstance {
    static ExerciseSubjectManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ExerciseSubjectManager alloc] init];
        [manager loadCache];
    });
    return manager;
}

- (void)requestSubjectsWithCompleteBlock:(SubjectRequestBlock)requestBlock{
    [self.subjectRequest stopRequest];
    self.subjectRequest = [[GetSubjectRequest alloc]init];
    self.subjectRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
    WEAK_SELF
    [self.subjectRequest startRequestWithRetClass:[GetSubjectRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(requestBlock,nil,error);
            return;
        }
        if ([[YXUserManager sharedManager].userModel.stageid isEqualToString:@"1202"] ) {//若为小学学段则去请求BC资源相关
            GetSubjectRequestItem *item = retItem;
            NSMutableArray *subjects = [NSMutableArray arrayWithArray:item.subjects];
            [self.topicRequest stopRequest];
            self.topicRequest = [[GetTopicRequest alloc]init];
            self.topicRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
            [self.topicRequest startRequestWithRetClass:[GetSubjectRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
                STRONG_SELF
                if (error) {
                    BLOCK_EXEC(requestBlock,nil,error);
                    return;
                }
                GetSubjectRequestItem *item0 = retItem;
                [subjects addObject:item0.subjects.firstObject];
                item.subjects = subjects.copy;
                [self saveSubjectToCache:item];
                BLOCK_EXEC(requestBlock,item,nil);
            }];
            return;
        }
        [self saveSubjectToCache:retItem];
        BLOCK_EXEC(requestBlock,retItem,nil);
    }];
}

- (void)requestEditionsWithSubjectID:(NSString *)subjectID completeBlock:(EditionRequestBlock)requestBlock{
    [self.editionRequest stopRequest];
    self.editionRequest = [[GetEditionRequest alloc]init];
    self.editionRequest.stageId = [YXUserManager sharedManager].userModel.stageid;;
    self.editionRequest.subjectId = subjectID;
    [self.editionRequest startRequestWithRetClass:[GetEditionRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        BLOCK_EXEC(requestBlock,retItem,error);
    }];
}

- (void)requestVolumesWithSubjectID:(NSString *)subjectID editionID:(NSString *)editionID completeBlock:(VolumeRequestBlock)requestBlock{
    [self.getVolumeRequest stopRequest];
    self.getVolumeRequest = [[GetVolumesRequest alloc]init];
    self.getVolumeRequest.stageId = [YXUserManager sharedManager].userModel.stageid;;
    self.getVolumeRequest.subjectId = subjectID;
    self.getVolumeRequest.editionId = editionID;
    [self.getVolumeRequest startRequestWithRetClass:[GetVolumesRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        if (error) {
            BLOCK_EXEC(requestBlock,nil,error);
            return;
        }
        GetVolumesRequestItem *item = retItem;
        BLOCK_EXEC(requestBlock,item.volumes,nil);
    }];
}

- (void)saveEditionWithSubjectID:(NSString *)subjectID editionID:(NSString *)editionID completeBlock:(SaveEditionRequestBlock)requestBlock{
    [self.saveEditionRequest stopRequest];
    self.saveEditionRequest = [[SaveEditionRequest alloc]init];
    self.saveEditionRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
    self.saveEditionRequest.subjectId = subjectID;
    self.saveEditionRequest.beditionId = editionID;
    WEAK_SELF
    [self.saveEditionRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(requestBlock,nil,error);
            return;
        }
        [self requestSubjectWithSubjectID:subjectID completeBlock:requestBlock];
    }];
}

- (void)requestSubjectWithSubjectID:(NSString *)subjectID completeBlock:(SaveEditionRequestBlock)requestBlock{
    [self requestSubjectsWithCompleteBlock:^(GetSubjectRequestItem *retItem, NSError *error) {
        if (error) {
            BLOCK_EXEC(requestBlock,nil,error);
            return;
        }
        GetSubjectRequestItem_subject *subject = nil;
        for (GetSubjectRequestItem_subject *s in retItem.subjects) {
            if ([subjectID isEqualToString:s.subjectID]) {
                subject = s;
                break;
            }
        }
        BLOCK_EXEC(requestBlock,subject,nil);
        [[NSNotificationCenter defaultCenter]postNotificationName:kSubjectSaveEditionInfoSuccessNotification object:nil];
    }];
}

- (void)saveVolumeWithSubjectID:(NSString *)subjectID volumeID:(NSString *)volumeID completeBlock:(SaveVolumeRequestBlock)requestBlock {
    [self.saveVolumeRequest stopRequest];
    self.saveVolumeRequest = [[SaveFavVolumeRequest alloc]init];
    self.saveVolumeRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
    self.saveVolumeRequest.subjectId = subjectID;
    self.saveVolumeRequest.volumeId = volumeID;
    WEAK_SELF
    [self.saveVolumeRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        BLOCK_EXEC(requestBlock,error);
    }];
}

#pragma mark -
- (GetSubjectRequestItem *)currentSubjectItem {
    NSString *stageID = [YXUserManager sharedManager].userModel.stageid;
    NSString *json = [self.subjectDictionary valueForKey:stageID];
    if (!json) {
        return nil;
    }
    return [[GetSubjectRequestItem alloc]initWithString:json error:nil];
}

#pragma mark - 存储
- (void)loadCache {
    NSString *subjectsCachePath = [self subjectsCachePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:subjectsCachePath]) {
        self.subjectDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:subjectsCachePath];
    }
    if (!self.subjectDictionary) {
        self.subjectDictionary = [NSMutableDictionary dictionary];
    }
}

- (void)saveSubjectToCache:(GetSubjectRequestItem *)item {
    NSString *stageID = [YXUserManager sharedManager].userModel.stageid;
    if (!item || !stageID) {
        return;
    }
    [self.subjectDictionary setObject:[item toJSONString] forKey:stageID];
    [NSKeyedArchiver archiveRootObject:self.subjectDictionary toFile:[self subjectsCachePath]];
}

- (NSString *)subjectsCachePath{
    return [NSString stringWithFormat:@"%@/subjects_new.dat", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]];
}

@end
