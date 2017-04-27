//
//  JoinClassPromptView.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/21/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXSearchClassRequest.h"
#import "TextInputView.h"


@interface JoinClassPromptView : UIView

@property (nonatomic, strong) TextInputView *inputView;
@property (nonatomic, strong) YXSearchClassItem_Data *rawData;
@property (nonatomic, copy) void(^joinAction) (void);

@end
