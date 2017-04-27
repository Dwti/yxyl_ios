//
//  YXQASingleChooseView_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAChooseView_Pad.h"
#import "YXAutoGoNextDelegate.h"

@interface YXQASingleChooseView_Pad : YXQAChooseView_Pad
@property (nonatomic, assign) id<YXAutoGoNextDelegate> delegate;
@end
