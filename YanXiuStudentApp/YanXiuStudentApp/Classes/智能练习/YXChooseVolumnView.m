//
//  YXVolumnChooseView.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/7/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXChooseVolumnView.h"
#import "YXExerciseChooseChapterKnp_ChooseVolumeCell.h"

static const CGFloat kContentViewHeight = 300.0f;
static const CGFloat kPickerViewRowHeight = 50.0f;

@interface YXChooseVolumnView () <UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *bottomLineView;
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
    [self.pickerView selectRow:index inComponent:0 animated:NO];
}

- (void)setupUI {
    self.maskView = [[UIView alloc]init];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    self.maskView.clipsToBounds = YES;
    [self addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.delegate = self;
    [self.maskView addGestureRecognizer:tap];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kContentViewHeight)];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    [self addSubview:self.contentView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
    
    self.cancelButton = [[UIButton alloc] init];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithHexString:@"336600"] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithHexString:@"69ad0a"] forState:UIControlStateHighlighted];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.height.equalTo(@50);
        make.left.mas_equalTo(self.contentView.mas_left).offset(30);
    }];
    
    self.confirmButton = [[UIButton alloc] init];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"336600"] forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"69ad0a"] forState:UIControlStateHighlighted];
    [self.confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.titleLabel.font = self.cancelButton.titleLabel.font;
    [self.contentView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.height.equalTo(self.cancelButton.mas_height);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-30);
    }];
    
    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"81d40d"];
    [self.contentView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.cancelButton.mas_bottom);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.contentView addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.top.equalTo(self.cancelButton.mas_bottom);
    }];
    [self clearSeparatorWithView:self.pickerView];
    
    UIView *rectView = [[UIView alloc]init];
    rectView.layer.cornerRadius = 6.f;
    rectView.layer.borderColor = [UIColor whiteColor].CGColor;
    rectView.layer.borderWidth = 2.f;
    rectView.clipsToBounds = YES;
    [self.pickerView addSubview:rectView];
    [rectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(250.f * kPhoneWidthRatio);
        make.height.mas_equalTo(kPickerViewRowHeight * kPhoneWidthRatio);
    }];
    self.lastSelectedIndex = 0;
}

- (void)tapAction {
    [self removeAnminationWithCompleteBlock:^{
        BLOCK_EXEC(self.chooseBlock,self.currentIndex,NO);
    }];
}

- (void)removeAnminationWithCompleteBlock:(void(^)())completeBlock {
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kContentViewHeight);
        self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
    } completion:^(BOOL finished) {
        BLOCK_EXEC(completeBlock);
    }];
}

- (void)showWithAnmination {
    [self clearSeparatorWithView:self.pickerView];
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT - kContentViewHeight, SCREEN_WIDTH, kContentViewHeight);
        self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    } completion:nil];
}

- (void)cancelAction:(id)sender
{
    [self removeAnminationWithCompleteBlock:^{
        BLOCK_EXEC(self.chooseBlock,self.currentIndex,NO);
    }];
}

- (void)confirmAction:(id)sender
{
    BOOL isChanged = self.lastSelectedIndex == self.currentIndex ? NO : YES;
    [self removeAnminationWithCompleteBlock:^{
        BLOCK_EXEC(self.chooseBlock,self.currentIndex,isChanged);
        self.lastSelectedIndex = self.currentIndex;
    }];
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

- (void)clearSeparatorWithView:(UIView * )view
{
    if(view.subviews != 0  )
    {
        if(view.bounds.size.height < 1)
        {
            view.backgroundColor = [UIColor clearColor];
        }
        
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
    
}
@end
