//
//  YXExerciseChooseEdition_ContainerView.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 1/27/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "YXExerciseChooseEdition_ContainerView.h"
#import "YXExerciseChooseEdition_SubjectView.h"
#import "YXExerciseChooseEdition_SubjectEditionListedView.h"

static const NSUInteger YXExerciseChooseEdition_SubjectItemTagBase = 8000;

@interface YXExerciseChooseEdition_ContainerView () <YXExerciseChooseEdition_SubjectViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *subjectArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGPoint formerScrollOffset;
@end

@implementation YXExerciseChooseEdition_ContainerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.maskView.hidden = YES;
    [self addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTap:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.maskView addGestureRecognizer:tap];
}

- (void)reloadWithSubjects:(NSArray *)subjects {
    self.subjectArray = subjects;
    
    for (UIView *v in self.contentView.subviews) {
        [v removeFromSuperview];
    }
    
    // 计算contentView的大小
    CGFloat width = kYXExerciseChooseEdition_SubjectView_Width * self.columnCount + self.hGap * (self.columnCount - 1);
    CGFloat height = kYXExerciseChooseEdition_SubjectView_Height * [self rowCount] + self.vGap * ([self rowCount] - 1);
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, height));
        make.top.mas_equalTo(self.vGap);
        make.bottom.mas_equalTo(-self.vGap);
        make.centerX.mas_equalTo(0);
    }];

    [self.scrollView setNeedsUpdateConstraints];
    [self.scrollView setNeedsLayout];
    
    for (int i = 0; i < [subjects count]; i++) {
        YXExerciseChooseEdition_SubjectView *v = [[YXExerciseChooseEdition_SubjectView alloc] init];
        v.tag = YXExerciseChooseEdition_SubjectItemTagBase + i;
        v.delegate = self;
        NSInteger row = i / self.columnCount;
        NSInteger column = i % self.columnCount;
        CGFloat x = (kYXExerciseChooseEdition_SubjectView_Width + self.hGap) * column;
        CGFloat y = (kYXExerciseChooseEdition_SubjectView_Height + self.vGap) * row;
        [self.contentView addSubview:v];
//        YXNodeElement *data = self.subjectArray[i];
//        [v updateWithData:data];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(x);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(y);
            make.size.mas_equalTo(CGSizeMake(kYXExerciseChooseEdition_SubjectView_Width, kYXExerciseChooseEdition_SubjectView_Height));
        }];
    }
}

- (void)showEditionsToChooseForSubject:(YXNodeElement *)subject {
    NSUInteger index = [self.subjectArray indexOfObject:subject];
    NSInteger row = index / self.columnCount;
    NSInteger column = index % self.columnCount;
    CGFloat x = (kYXExerciseChooseEdition_SubjectView_Width + self.hGap) * column;
    CGFloat y = (kYXExerciseChooseEdition_SubjectView_Height + self.vGap) * row;

    self.formerScrollOffset = self.scrollView.contentOffset;
    
    // 开始做动画
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, row * (self.vGap + kYXExerciseChooseEdition_SubjectView_Height));
    } completion:^(BOOL finished) {
        self.maskView.hidden = NO;
        YXExerciseChooseEdition_SubjectEditionListedView *v = [[YXExerciseChooseEdition_SubjectEditionListedView alloc] init];
        v.gapToCalculateHeight = 50;    // pad magical number 这个以后再改
        [self.maskView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kYXExerciseChooseEdition_SubjectView_Height);
            make.width.mas_equalTo(kYXExerciseChooseEdition_SubjectView_Width);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(x);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(y);
        }];
//        [v updateWithData:subject];
//        v.choosenBlock = ^void(YXNodeElement *edition) {
//            [self maskTap:nil];
//            if ([self.delegate respondsToSelector:@selector(edition:ChoosedForSubject:)]) {
//                [self.delegate edition:edition ChoosedForSubject:subject];
//            }
//        };
    }];
}

- (NSInteger)rowCount {
    return ([self.subjectArray count] + self.columnCount - 1) / self.columnCount;
}

- (void)maskTap:(UIGestureRecognizer *)tap {
    for (UIView *v in self.maskView.subviews) {
        [v removeFromSuperview];
    }
    
    self.maskView.hidden = YES;
    self.scrollView.contentOffset = self.formerScrollOffset;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.maskView) {
        return YES;
    }
    return NO;
}

#pragma mark - YXExerciseChooseEdition_SubjectViewDelegate
- (void)subjectViewSubjectTapped:(YXExerciseChooseEdition_SubjectView *)view {
//    NSInteger index = view.tag - YXExerciseChooseEdition_SubjectItemTagBase;
//    YXNodeElement *subject = self.subjectArray[index];
//    
//    if (isEmpty(subject.data)) {
//        [self subjectViewChooseEditionTapped:view];
//    } else {
//        SAFE_CALL_OneParam(self.delegate, gotoChooseChapterKnpForSubject, subject);
//    }
}

- (void)subjectViewChooseEditionTapped:(YXExerciseChooseEdition_SubjectView *)view {
//    NSInteger index = view.tag - YXExerciseChooseEdition_SubjectItemTagBase;
//    YXNodeElement *subject = self.subjectArray[index];
//    
//    SAFE_CALL_OneParam(self.delegate, chooseEditionForSubject, subject);
}

@end
