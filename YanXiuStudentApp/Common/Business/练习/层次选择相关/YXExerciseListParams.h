//
//  YXExerciseListParams.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YXExerciseListType) {
    YXExerciseListTypeQuiz,    //智能练习
    YXExerciseListTypeMistake, //我的错题
    YXExerciseListTypeFavorite //我的收藏
};

typedef NS_ENUM(NSInteger, YXExerciseListSegment) {
    YXExerciseListSegmentChapter,  //按章节
    YXExerciseListSegmentTestItem, //按考点
};

@interface YXExerciseListParams : NSObject
@property (nonatomic, strong) NSString *stageId;   //学段id
@property (nonatomic, strong) NSString *subjectId; //学科id
@property (nonatomic, strong) NSString *editionId; //教材版本id
@property (nonatomic, strong) NSString *volumeId;  //册id

@property (nonatomic, assign) YXExerciseListType type; //练习列表类型
@property (nonatomic, assign) YXExerciseListSegment segment; //分类
@end
