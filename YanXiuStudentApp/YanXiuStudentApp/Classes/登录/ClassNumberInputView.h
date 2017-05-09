//
//  ClassNumberInputView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassNumberInputView : UIView
@property (nonatomic, assign) NSInteger numberCount;
@property (nonatomic, copy) void(^textChangeBlock)(NSString *text);
@end
