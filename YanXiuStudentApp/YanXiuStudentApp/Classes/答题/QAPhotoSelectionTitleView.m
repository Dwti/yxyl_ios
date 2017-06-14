//
//  QAPhotoSelectionTitleView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAPhotoSelectionTitleView.h"

@interface QAPhotoSelectionTitleView()
@property (nonatomic, strong) UIButton *button;
@end

@implementation QAPhotoSelectionTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.button = [[UIButton alloc]initWithFrame:self.bounds];
    [self.button setImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 15, 15)] forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [self.button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
    
    self.isFold = YES;
}

- (void)btnAction {
    BLOCK_EXEC(self.statusChangedBlock);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.button setTitle:title forState:UIControlStateNormal];
    [self.button.titleLabel sizeToFit];
    self.button.titleEdgeInsets = UIEdgeInsetsMake(0, -15-4, 0, 15+4);
    self.button.imageEdgeInsets = UIEdgeInsetsMake(0, self.button.titleLabel.width+4, 0, -self.button.titleLabel.width-4);
}

- (void)setIsFold:(BOOL)isFold {
    _isFold = isFold;
    if (isFold) {
        [UIView animateWithDuration:0.3 animations:^{
            self.button.imageView.transform = CGAffineTransformIdentity;
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
}

@end
