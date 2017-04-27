//
//  ClassInfoView.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/12/21.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXClassInfoMock.h"

@interface ClassInfoView : UIView
@property (nonatomic, weak) YXClassInfoMock *data;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) YXClassActionType actionType;
@end
