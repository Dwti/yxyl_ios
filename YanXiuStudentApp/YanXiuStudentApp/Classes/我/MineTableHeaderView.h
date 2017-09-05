//
//  MineTableHeaderView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableHeaderView : UIView

@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) void(^enterBlock) ();
@property (nonatomic, assign) CGFloat offsetRate;

@end
