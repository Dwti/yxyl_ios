//
//  YXChooseVolumnButton.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/7/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXChooseVolumnButton : UIButton
- (CGSize)updateWithTitle:(NSString *)title;

@property (nonatomic, assign) BOOL bExpand;
@end
