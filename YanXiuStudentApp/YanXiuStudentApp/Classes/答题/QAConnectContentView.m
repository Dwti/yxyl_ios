//
//  QAConnectContentView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAConnectContentView.h"
#import "QAConnectOptionsView.h"

static const CGFloat kGapWidth = 15.f;

@interface QAConnectContentView ()
@property (nonatomic, strong) QAConnectOptionsView *leftView;
@property (nonatomic, strong) QAConnectOptionsView *rightView;
@property (nonatomic, strong) NSMutableArray *leftOPtionArray;
@property (nonatomic, strong) NSMutableArray *rightOptionArray;
@property (nonatomic, copy) NSString *leftSelectedOptionString;
@property (nonatomic, copy) NSString *rightSelectedOptionString;
@property (nonatomic, strong) NSMutableArray *leftSelectedArray;
@property (nonatomic, strong) NSMutableArray *rightSelectedArray;
@end

@implementation QAConnectContentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.leftOPtionArray = [NSMutableArray array];
        self.rightOptionArray = [NSMutableArray array];
        self.leftSelectedArray = [NSMutableArray array];
        self.rightSelectedArray = [NSMutableArray array];
    }
    return self;
}

- (void)setupUI{
    self.leftView = [[QAConnectOptionsView alloc]init];
    WEAK_SELF
    [self.leftView setSelectedOptionCellActionBlock:^(NSString *optionString) {
        STRONG_SELF
        DDLogDebug(@"左边-选中了%@cell的选项",optionString);
        self.leftSelectedOptionString = optionString;
        [self resetSelectedOPtions];
    }];
    self.rightView = [[QAConnectOptionsView alloc]init];
    [self.rightView setSelectedOptionCellActionBlock:^(NSString *optionString) {
        STRONG_SELF
        DDLogDebug(@"右边-选中了%@cell的选项",optionString);
        self.rightSelectedOptionString = optionString;
        [self resetSelectedOPtions];
    }];
    
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    [@[self.leftView,self.rightView] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kGapWidth leadSpacing:0 tailSpacing:0];
    [@[self.leftView,self.rightView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}


- (void)setItem:(QAQuestion *)item{
    //    if (self.item) {
    //        return;
    //    }
    _item = item;
    
    NSMutableArray *groupArray = [NSMutableArray array];
    NSMutableArray *leftArray = [NSMutableArray array];
    NSMutableArray *rightArray = [NSMutableArray array];
    NSInteger groupCount = item.options.count/2;
    for (int i = 0; i < groupCount; i++) {
        NSString *leftOption = item.options[i];
        NSString *rightOption = item.options[i+groupCount];
        [leftArray addObject:leftOption];
        [rightArray addObject:rightOption];
    }
    self.leftView.optionsArray = leftArray;
    self.rightView.optionsArray = rightArray;
    self.leftOPtionArray = leftArray;
    self.rightOptionArray = rightArray;
    [groupArray arrayByAddingObjectsFromArray:leftArray];
    [groupArray addObjectsFromArray:rightArray];
    self.groupArray = groupArray.copy;
}

- (void)resetSelectedOPtions {
    DDLogDebug(@"重置状态:左边选中%@----右边选中%@",self.leftSelectedOptionString,self.rightSelectedOptionString);
    if (!isEmpty(self.leftSelectedOptionString) && !isEmpty(self.rightSelectedOptionString)) {
        if ([self.leftOPtionArray containsObject:self.leftSelectedOptionString]) {
            [self.leftOPtionArray removeObject:self.leftSelectedOptionString];
            self.leftView.optionsArray = self.leftOPtionArray;
            [self.leftView reloadData];
            [self.leftSelectedArray addObject:self.leftSelectedOptionString];
        }
        if ([self.rightOptionArray containsObject:self.rightSelectedOptionString]) {
            [self.rightOptionArray removeObject:self.rightSelectedOptionString];
            self.rightView.optionsArray = self.rightOptionArray;
            [self.rightView reloadData];
            [self.rightSelectedArray addObject:self.rightSelectedOptionString];
        }
        self.leftSelectedOptionString = nil;
        self.rightSelectedOptionString = nil;
    }
}
@end
