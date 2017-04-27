//
//  YXQASubmitSuccessAndBackView_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/4/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXQASubmitSuccessAndBackView_Pad : UIView
@property (nonatomic, copy) void(^actionBlock)();
@property (nonatomic, strong) NSDate *endDate;
@end
