//
//  SimpleAlertButton.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/4.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SimpleAlertActionStyle) {
    SimpleAlertActionStyle_Alone = 0,
    SimpleAlertActionStyle_Default = 1,
    SimpleAlertActionStyle_Cancel = 2,
} ;

@interface SimpleAlertButton : UIButton
@property (nonatomic, assign) SimpleAlertActionStyle style;
@end
