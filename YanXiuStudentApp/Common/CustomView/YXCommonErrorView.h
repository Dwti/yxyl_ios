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

@property (nonatomic, strong) NSString *errorMsg; // 默认为：网络故障，请检查重试
@property (nonatomic, strong) UIImage *errorImage;
@property (nonatomic, copy) void(^retryBlock)();

@property (nonatomic, strong) NSString *errorCode;

@end
