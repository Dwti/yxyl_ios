//
//  YXStageViewController.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMineBaseViewController.h"

// 学段选择界面
@interface YXStageViewController : YXMineBaseViewController

@property (nonatomic, strong) NSString *stageid;

@property (nonatomic, copy) void (^selectBlock)(NSString *stageId, NSString *stageName);

@property (nonatomic, assign) BOOL isRegisterAccount;

@end
