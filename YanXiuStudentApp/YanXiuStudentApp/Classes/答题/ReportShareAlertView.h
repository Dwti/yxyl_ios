//
//  ReportShareAlertView.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/21/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportShareAlertView : UIView
@property (nonatomic, copy) void(^shareAction)(UIButton* sender);
@property (nonatomic, copy) void(^cancelAction)(void);
@end
