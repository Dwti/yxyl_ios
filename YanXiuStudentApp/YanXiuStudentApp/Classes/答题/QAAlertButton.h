//
//  QAAlertButton.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QAAlertActionStyle) {
    QAAlertActionStyle_Alone = 0,
    QAAlertActionStyle_Default = 1,
    QAAlertActionStyle_Cancel = 2,
} ;
@interface QAAlertButton : UIButton
@property (nonatomic, assign) QAAlertActionStyle style;
@end
