//
//  ExtendTextField.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ExtendTextField.h"

@implementation ExtendTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0, self.verticalMargin);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0, self.verticalMargin);
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0, self.verticalMargin);
}


@end
