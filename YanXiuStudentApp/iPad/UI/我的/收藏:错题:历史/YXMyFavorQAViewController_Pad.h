//
//  YXMyFavorQAViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 9/21/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXQAAnalysisViewController_Pad.h"

@interface YXMyFavorQAViewController_Pad : YXQAAnalysisViewController_Pad
@property (nonatomic, strong) YXQARequestParams *exeRequestParams;
@property (nonatomic, assign) YXSavedExerciseComeFrom comeFrom;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) BOOL bDataFromDB;

@property (nonatomic, strong) YXNodeElement *rawModel;

@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *editionId;
@property (nonatomic, copy) NSString *volumeId;

@property (nonatomic, copy) NSString *chapterId;
@property (nonatomic, copy) NSString *sectionId;
@property (nonatomic, copy) NSString *unitId;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end
