//
//  StagePromptView.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/21/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StagePromptView : UIView
@property (nonatomic, copy) void(^cancelAction) (void);
@property (nonatomic, copy) void(^editAction) (void);
@end
