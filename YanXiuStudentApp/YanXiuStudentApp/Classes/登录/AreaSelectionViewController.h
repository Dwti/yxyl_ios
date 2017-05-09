//
//  AreaSelectionViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "YXSchoolSearchRequest.h"

@interface AreaSelectionViewController : BaseViewController
@property (nonatomic, strong) void(^schoolSearchBlock)(YXSchool *school);
@property (nonatomic, weak) UIViewController *baseVC;
@end
