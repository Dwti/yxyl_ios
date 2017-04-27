//
//  YXHomeworkGroupMock.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/9/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXHomeworkListGroupsRequest.h"
typedef NS_ENUM(NSInteger, HomeworkGroupState) {
    HomeworkGroupState_Finished,
    HomeworkGroupState_Ongoing,
    HomeworkGroupState_Verifying,
    HomeworkGroupState_Denied
};

@interface YXHomeworkGroupMock : JSONModel
@property (nonatomic, strong) NSURL *iconUrl;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *homeworkInfo;
@property (nonatomic, assign) HomeworkGroupState state;

@property (nonatomic, strong) YXHomeworkListGroupsItem_Data *rawData;

+ (YXHomeworkGroupMock *)mockWithRealItem:(YXHomeworkListGroupsItem_Data *)data;

@end
