//
//  SearchClassView.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/12/21.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberInputView.h"

@interface SearchClassView : UIView
@property (nonatomic, strong) EEAlertButton *nextStepButton;
@property (nonatomic, strong) NumberInputView *groupFiled;
@property (nonatomic, copy) NSString *text;
@end
