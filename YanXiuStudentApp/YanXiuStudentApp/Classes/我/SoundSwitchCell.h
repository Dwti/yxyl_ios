//
//  SoundSwitchCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/9/11.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SwitchActionBlock) (BOOL isOn);

@interface SoundSwitchCell : UITableViewCell
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) BOOL shouldShowShadow;

- (void)setSwitchActionBlock:(SwitchActionBlock)block;
@end
