//
//  ListenComplexPromptView.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/21/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListenComplexPromptView : UIView
@property (nonatomic, copy) void(^okAction) (void);
@end
