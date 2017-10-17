//
//  HomeworkAddClassView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeworkAddClassView : UIView
@property (nonatomic, strong, readonly) NSString *classNumberString;
@property (nonatomic, strong) void(^nextStepBlock)(void);
@property (nonatomic, strong) void(^helpBlock)(void);
@end
