//
//  MineActionView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineActionView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) void(^actionBlock) (void);
@property (nonatomic, assign) BOOL isActive;
@end
