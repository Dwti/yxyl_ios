//
//  YXSideMenuViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/19.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXBaseViewController_Pad.h"

@protocol YXSideMenuPadDelegate <NSObject>
- (void)sideMenuPadDidSelectIndex:(NSInteger)index;
@end

@interface YXSideMenuViewController_Pad : YXBaseViewController_Pad
@property (nonatomic, weak) id<YXSideMenuPadDelegate> delegate;

- (void)selectIndex:(NSInteger)index;

@end
