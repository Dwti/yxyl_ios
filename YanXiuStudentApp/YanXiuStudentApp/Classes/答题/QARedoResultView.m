//
//  QARedoResultView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/11/29.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QARedoResultView.h"
@interface QARedoResultView()
@property (nonatomic, strong) UIImageView *resultImageView;
@end

@implementation QARedoResultView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"发散背景"]];
    [self addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(56);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(backImageView.mas_width);
    }];
    
    self.resultImageView = [[UIImageView alloc] init];
    [backImageView addSubview:self.resultImageView];
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(47.5f, 47.5f, 47.5f, 47.5f));
    }];
}

- (void)setResultImage:(UIImage *)resultImage {
    _resultImage = resultImage;
    self.resultImageView.image = resultImage;
}
@end
