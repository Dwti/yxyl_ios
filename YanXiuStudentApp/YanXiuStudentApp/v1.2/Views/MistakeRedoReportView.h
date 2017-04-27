//
//  MistakeRedoReportView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MistakeRedoReportView : UIView
@property (nonatomic, strong) NSString *reportString;
@property (nonatomic, copy) void(^exitAction) (void);
@property (nonatomic, copy) void(^continueAction) (void);
@end
