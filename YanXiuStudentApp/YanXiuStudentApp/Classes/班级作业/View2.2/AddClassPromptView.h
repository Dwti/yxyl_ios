//
//  AddClassPromptView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/12/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddClassPromptView : UIView

@property (nonatomic, copy) void(^helpAction) (void);
@property (nonatomic, copy) void(^joinAction) (void);

@end
