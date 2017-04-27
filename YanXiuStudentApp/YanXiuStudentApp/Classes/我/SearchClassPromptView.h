//
//  SearchClassPromptView.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/21/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberInputView.h"

@interface SearchClassPromptView : UIView
@property (nonatomic, strong) NumberInputView *groupFiled;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) void(^nextAction) (void);
@property (nonatomic, copy) void(^skipAction) (void);
@end
