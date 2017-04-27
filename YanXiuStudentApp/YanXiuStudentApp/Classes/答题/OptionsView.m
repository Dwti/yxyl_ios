//
//  OptionsView.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "OptionsView.h"

@interface OptionsView()

@end

@implementation OptionsView

#pragma mark- Get
- (CGSize)contentSize{
    return self.bgScrollView.contentSize;
}

- (UIButton *)closeButtonWithObj:(id)obj{
    if (!self.selected || self.isAnalysis) {//选项与解析没有删除按钮
        return nil;
    }
    UIButton *closeButton = [UIButton new];
    [closeButton setImage:[UIImage imageNamed:@"错"] forState:UIControlStateNormal];
    [closeButton sizeToFit];
    WEAK_SELF
    [[closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.deleteBlock) {
            self.deleteBlock(obj);
        }
    }];
    return closeButton;
}

#pragma mark- Set
- (void)setContentSize:(CGSize)contentSize{
    self.bgScrollView.contentSize = contentSize;
}

- (void)setDatas:(NSMutableArray *)datas{
    _datas = datas;
    [self.bgScrollView removeAllSubviews];
    [self.views removeAllObjects];
    if (self.selected) {
        [self.bgScrollView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset = 0;
            make.top.offset = 0;
        }];
    }
}

- (void)setCurrentView:(UIView *)currentView{
    _currentView.alpha = 1;
    if ([_currentView isEqual:currentView]) {
        _currentView = nil;
        return;
    }
    _currentView = currentView;
    _currentView.alpha = 0.5;
}

#pragma mark-
- (instancetype)initWithDataType:(OptionsDataType)type{
    OptionsView *view;
    view.backgroundColor = [UIColor clearColor];
    if (type == OptionsImageDataType) {
        view = [NSClassFromString(@"OptionsImageView") new];
    }else{
        view = [NSClassFromString(@"OptionsStringView") new];
    }
    return view;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    self.views = [NSMutableArray new];
    self.bgScrollView = [UIScrollView new];
    self.bgScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgScrollView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 90;
    self.titleLabel.numberOfLines = 0;
}

- (void)setupLayout{
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

@end
