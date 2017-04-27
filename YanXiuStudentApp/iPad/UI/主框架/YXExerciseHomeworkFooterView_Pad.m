//
//  YXExerciseHomeworkFooterView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXExerciseHomeworkFooterView_Pad.h"

@implementation YXExerciseHomeworkFooterView_Pad

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"008080"];
    }
    return self;
}

@end
