//
//  YXCommonErrorView.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/28.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  网络请求通用错误界面
 */
@interface YXCommonErrorView : UIView
@property (nonatomic, copy) void(^retryBlock)(void);
@end
