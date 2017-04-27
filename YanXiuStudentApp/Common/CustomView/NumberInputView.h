//
//  NumberInputView.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/22/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberInputView : UIView
@property (nonatomic, assign) NSInteger numberCount;
@property (nonatomic, copy) void(^textChangeBlock)(NSString *text);
@end
