//
//  ExerciseSubjectManager.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetSubjectRequest.h"
#import "GetEditionRequest.h"

extern NSString *const kSubjectSaveEditionInfoSuccessNotification;

typedef void(^SubjectRequestBlock)(GetSubjectRequestItem *retItem, NSError *error);
typedef void(^EditionRequestBlock)(GetEditionRequestItem *retItem, NSError *error);
typedef void(^SaveEditionRequestBlock)(GetSubjectRequestItem_subject *retItem, NSError *error);
typedef void(^VolumeRequestBlock)(NSArray *volumeArray, NSError *error);// volume class is GetEditionRequestItem_edition_volume

@interface ExerciseSubjectManager : NSObject

+ (instancetype)sharedInstance;

- (GetSubjectRequestItem *)currentSubjectItem;

- (void)requestSubjectsWithCompleteBlock:(SubjectRequestBlock)requestBlock;
- (void)requestEditionsWithSubjectID:(NSString *)subjectID completeBlock:(EditionRequestBlock)requestBlock;
- (void)requestVolumesWithSubjectID:(NSString *)subjectID editionID:(NSString *)editionID completeBlock:(VolumeRequestBlock)requestBlock;
- (void)saveEditionWithSubjectID:(NSString *)subjectID editionID:(NSString *)editionID completeBlock:(SaveEditionRequestBlock)requestBlock;

@end
