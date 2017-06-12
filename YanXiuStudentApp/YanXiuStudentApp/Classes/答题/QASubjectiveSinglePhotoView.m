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
    self.photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    self.photoImageView.center = CGPointMake(self.width/2, self.height/2);
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView.layer.cornerRadius = 6;
    self.photoImageView.clipsToBounds = YES;
    self.photoImageView.userInteractionEnabled = YES;
    [self addSubview:self.photoImageView];
    
    self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width-18, 0, 18, 18)];
    [self.deleteButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
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
