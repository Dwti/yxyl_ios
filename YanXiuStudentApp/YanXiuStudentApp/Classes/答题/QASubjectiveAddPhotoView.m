//
//  QASubjectiveAddPhotoView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QASubjectiveAddPhotoView.h"

@implementation QASubjectiveAddPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 6;
    self.layer.borderWidth = 3;
    self.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    self.clipsToBounds = YES;
    UIButton *button = [[UIButton alloc]initWithFrame:self.bounds];
    [button setImage:[UIImage imageNamed:@"添加图片上传icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)btnAction {
    BLOCK_EXEC(self.addAction);
}

@end
