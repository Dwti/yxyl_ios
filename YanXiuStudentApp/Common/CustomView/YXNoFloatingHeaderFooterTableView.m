//
//  YXNoFloatingHeaderFooterTableView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/7/23.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXNoFloatingHeaderFooterTableView.h"

@implementation YXNoFloatingHeaderFooterTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)allowsHeaderViewsToFloat {
    return NO;
}
- (BOOL)allowsFooterViewsToFloat {
    return NO;
}

@end
