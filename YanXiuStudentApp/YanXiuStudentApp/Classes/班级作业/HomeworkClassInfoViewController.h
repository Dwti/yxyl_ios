//
//  HomeworkClassInfoViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ScrollBaseViewController.h"

@interface HomeworkClassInfoViewController : ScrollBaseViewController
@property (nonatomic, strong) YXSearchClassItem_Data *rawData;
@property (nonatomic, assign) BOOL isVerifying;
@end
