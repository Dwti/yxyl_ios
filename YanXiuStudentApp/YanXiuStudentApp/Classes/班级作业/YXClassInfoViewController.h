//
//  YXClassInfoViewController.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/9/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "YXClassInfoMock.h"
#import "YXSearchClassRequest.h"

@interface YXClassInfoViewController : BaseViewController
@property (nonatomic, assign) YXClassActionType actionType;
@property (nonatomic, strong) YXSearchClassItem_Data *rawData;

@end
