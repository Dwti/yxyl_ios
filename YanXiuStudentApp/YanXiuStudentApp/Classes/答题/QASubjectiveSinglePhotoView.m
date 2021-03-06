//
//  QASubjectiveSinglePhotoView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QASubjectiveSinglePhotoView.h"

@interface QASubjectiveSinglePhotoView()
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation QASubjectiveSinglePhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, self.width-8, self.width-8)];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView.layer.cornerRadius = 6;
    self.photoImageView.layer.borderWidth = 2;
    self.photoImageView.clipsToBounds = YES;
    self.photoImageView.userInteractionEnabled = YES;
    [self addSubview:self.photoImageView];
    
    self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width-18, 0, 18, 18)];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"小图片删除按钮正常态"] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"小图片删除按钮点击态"] forState:UIControlStateHighlighted];
    [self.deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
    self.deleteButton.hidden = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.photoImageView addGestureRecognizer:longPress];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singeTap:)];
    [self.photoImageView addGestureRecognizer:tap];
}

- (void)setImageAnswer:(QAImageAnswer *)imageAnswer {
    _imageAnswer = imageAnswer;
    self.photoImageView.image = imageAnswer.data;
    if (imageAnswer.url) {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:imageAnswer.url] placeholderImage:nil];
    }
}

- (void)setShowImageBorder:(BOOL)showImageBorder {
    _showImageBorder = showImageBorder;
    if (showImageBorder) {
        self.photoImageView.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    }else {
        self.photoImageView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)deleteAction {
    BLOCK_EXEC(self.deleteBlock);
}

#pragma mark - Gesture
- (void)longPress:(UILongPressGestureRecognizer *)gesture {
    if (!self.canDelete) {
        return;
    }
    self.deleteButton.hidden = NO;
}

- (void)singeTap:(UITapGestureRecognizer *)gesture {
    if (!self.deleteButton.hidden) {
        self.deleteButton.hidden = YES;
        return;
    }
    BLOCK_EXEC(self.clickBlock);
}

@end
