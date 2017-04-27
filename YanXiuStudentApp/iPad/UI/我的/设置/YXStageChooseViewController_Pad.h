//
//  YXStageChooseViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSettingBaseViewController_Pad.h"

@interface YXStageChooseViewController_Pad : YXSettingBaseViewController_Pad

@property (nonatomic, strong) NSString *stageid;

@property (nonatomic, copy) void (^selectBlock)(NSString *stageId, NSString *stageName);

@end
