//
//  YXExerciseHomeworkHeaderView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXExerciseHomeworkHeaderView_Pad.h"

@implementation YXExerciseHomeworkHeaderView_Pad

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"008080"];
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor colorWithHexString:@"008787"];
    [self.contentView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

@end
