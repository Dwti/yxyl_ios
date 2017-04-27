//
//  UpdateAppAlertView.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/20/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXInitRequest.h"

@interface UpdateAppPromptView : UIView
@property (nonatomic, strong) YXInitRequestItem_Body *body;
@property (nonatomic, copy) void(^cancelAction) (void);
@property (nonatomic, copy) void(^updateAction) (void);
@end
