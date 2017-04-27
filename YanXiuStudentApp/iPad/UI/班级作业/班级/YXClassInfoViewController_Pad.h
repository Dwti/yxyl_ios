//
//  YXClassInfoViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXBaseViewController_Pad.h"
#import "YXClassInfoMock.h"
#import "YXSearchClassRequest.h"

@interface YXClassInfoViewController_Pad : YXBaseViewController_Pad

@property (nonatomic, assign) YXClassActionType actionType;
@property (nonatomic, strong) YXSearchClassItem_Data *rawData;

@end
