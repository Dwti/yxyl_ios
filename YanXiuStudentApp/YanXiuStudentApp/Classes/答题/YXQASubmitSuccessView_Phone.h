//
//  YXQASubmitSuccessView_Phone.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/4/6.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXSubmitQuestionRequest.h"

@interface YXQASubmitSuccessView_Phone : UIView
@property (nonatomic, copy) void(^actionBlock)();
@property (nonatomic, assign) YXPType pType;
@end
