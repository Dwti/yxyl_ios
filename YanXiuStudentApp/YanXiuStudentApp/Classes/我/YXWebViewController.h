//
//  YXWebViewController.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/17.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  包含网络错误处理的web视图控制器
 */
@interface YXWebViewController : BaseViewController

- (instancetype)initWithUrl:(NSString *)url;

@end
