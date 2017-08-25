//
//  ChooseEditionViewController.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^ChooseEditionSuccessBlock)(GetSubjectRequestItem_subject *subject);

typedef NS_ENUM(NSInteger, ChooseEditionFromType) {
    ChooseEditionFromType_ExerciseMain, //练习主页面
    ChooseEditionFromType_PersonalCenter, //个人中心
};

@interface ChooseEditionViewController : BaseViewController
@property (nonatomic, strong) GetSubjectRequestItem_subject *subject;
@property (nonatomic, assign) ChooseEditionFromType type;
@property (nonatomic, strong) GetEditionRequestItem *item;

- (void)setChooseEditionSuccessBlock:(ChooseEditionSuccessBlock)block;

@end
