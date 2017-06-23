//
//  QASubmitButton.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/29.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QASubmitButton.h"

@interface QASubmitButton ()
@property (nonatomic, copy) SubmitBlock block;

@end

@implementation QASubmitButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.layer.cornerRadius = 6.0f;
    self.clipsToBounds = YES;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [self setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"cccccc"]] forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"69ad0a"]] forState:UIControlStateHighlighted];
    [self addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submitButtonAction {
    BLOCK_EXEC(self.block);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setSubmitBlock:(SubmitBlock)block {
    self.block = block;
}

@end
