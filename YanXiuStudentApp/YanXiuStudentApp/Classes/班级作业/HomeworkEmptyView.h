//
//  HomeworkEmptyView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeworkEmptyView : UIView
@property (nonatomic, strong) void(^refreshBlock)(void);
@end
