//
//  YXMasterProgressView.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/8/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXMasterProgressView.h"

@interface YXMasterProgressView ()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *progressView;
@end

@implementation YXMasterProgressView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, 10, 9)];
    if (self) {
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    UIImage *bgImage = [[UIImage imageNamed:@"进度条背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    UIImage *progressImage = [[UIImage imageNamed:@"进度条"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];

    self.bgView = [[UIImageView alloc] initWithImage:bgImage];
    self.progressView = [[UIImageView alloc] initWithImage:progressImage];
    
    [self addSubview:self.bgView];
    [self addSubview:self.progressView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(self.progress);
    }];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(_progress);
    }];
}

@end
