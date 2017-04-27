//
//  UIView+Views.m
//  Record
//
//  Created by 贾培军 on 16/3/17.
//  Copyright © 2016年 贾培军. All rights reserved.
//

#import "UIView+Views.h"

@implementation UIView (Views)

@dynamic viewController;
@dynamic navigationController;

#pragma mark- Get

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (UIViewController *)viewController
{
    for (UIView *view = self; view; view = view.superview) {
        if ([view.nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)view.nextResponder;
        }
    }
    return nil;
}

- (UINavigationController *)navigationController
{
    return self.viewController.navigationController;
}

#pragma mark- Set

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}


- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

#pragma mark- function
- (void)packUpKeyboard
{
    [self endEditing:YES];
}

- (void)removeAllSubviews
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}

#pragma mark- Copy
+ (UILabel *)copyLabel:(UILabel *)label {
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:label];
    UILabel* copy = [NSKeyedUnarchiver unarchiveObjectWithData: archivedData];
    return copy;
}

+ (UITextField *)copyTextField:(UITextField *)label {
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:label];
    UITextField* copy = [NSKeyedUnarchiver unarchiveObjectWithData: archivedData];
    return copy;
}

+ (UIButton *)copyButton:(UIButton *)button {
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:button];
    UIButton* copy = [NSKeyedUnarchiver unarchiveObjectWithData: archivedData];
    return copy;
}

@end
