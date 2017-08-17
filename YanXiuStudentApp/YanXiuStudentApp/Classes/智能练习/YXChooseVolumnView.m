//
//  YXVolumnChooseView.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/7/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXChooseVolumnView.h"
#import "YXExerciseChooseChapterKnp_ChooseVolumeCell.h"

static const CGFloat kPickerViewHeight = 250.0f;
static const CGFloat kPickerViewRowHeight = 50.0f;

@interface YXChooseVolumnView () <UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@end

@implementation YXChooseVolumnView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)updateWithDatas:(NSArray *)dataArray selectedIndex:(NSInteger)index {
    self.dataArray = dataArray;
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:self.lastSelectedIndex inComponent:0 animated:NO];
}

- (void)setupUI {
    self.maskView = [[UIView alloc]init];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    self.maskView.clipsToBounds = YES;
    [self addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self.maskView addGestureRecognizer:tap];
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kPickerViewHeight)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    [self addSubview:self.pickerView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.pickerView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.pickerView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.pickerView.layer.mask = maskLayer;

    UIView *rectView = [[UIView alloc]init];
    rectView.layer.cornerRadius = 6.f;
    rectView.layer.borderColor = [UIColor whiteColor].CGColor;
    rectView.layer.borderWidth = 2.f;
    rectView.clipsToBounds = YES;
    [self.pickerView addSubview:rectView];
    [rectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(250.f);
        make.height.mas_equalTo(kPickerViewRowHeight);
    }];
    self.lastSelectedIndex = 0;
}

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    BOOL isChanged = self.lastSelectedIndex == self.currentIndex ? NO : YES;
    [self removeAnminationWithCompleteBlock:^{
        BLOCK_EXEC(self.chooseBlock,self.currentIndex,isChanged);
        self.lastSelectedIndex = self.currentIndex;
    }];
}

- (void)removeAnminationWithCompleteBlock:(void(^)())completeBlock {
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kPickerViewHeight);
        self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
    } completion:^(BOOL finished) {
        BLOCK_EXEC(completeBlock);
    }];
}

- (void)showWithAnmination {
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT - kPickerViewHeight, SCREEN_WIDTH, kPickerViewHeight);
        self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    } completion:nil];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataArray count];
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return kPickerViewRowHeight ;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor clearColor];
        }
    }
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, row * kPickerViewRowHeight, SCREEN_WIDTH, kPickerViewRowHeight)];
        label.font = [UIFont boldSystemFontOfSize:23.f];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    GetEditionRequestItem_edition_volume *volume = self.dataArray[row];
    label.text = volume.name;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentIndex = row;
}
@end
