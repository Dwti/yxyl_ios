//
//  YXBaseWebViewController.h
//  YanXiuStudentApp
//
//  Created by wd on 15/11/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSUInteger, WebViewshowType) {
    WebViewshowType_Push,
    WebViewshowType_Present,
};


@interface YXBaseWebViewController : BaseViewController

@property (nonatomic, assign) WebViewshowType   showType;

- (instancetype)initWithUrlString:(NSString *)urlString;

@end
