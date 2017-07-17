//
//  StageSelectionViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"

@interface StageSelectionViewController : BaseViewController
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) void(^completeBlock)(NSString *stageName,NSString *stageID);
@end
