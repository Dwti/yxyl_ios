//
//  MyProfileTableHeaderView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileTableHeaderView : UIView
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) void(^editBlock) (void);
@end
