//
//  UIResponder+FirstResponder.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 10/13/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

static __weak id currentFirstResponder;

@implementation UIResponder (FirstResponder)

+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}
@end
