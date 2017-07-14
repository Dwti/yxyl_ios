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
@property (nonatomic, strong) NSMutableArray<QAConnectOptionInfo *> *leftOPtionArray;
@property (nonatomic, strong) NSMutableArray<QAConnectOptionInfo *> *rightOptionArray;
@property (nonatomic, strong) QAConnectOptionInfo *leftSelectedOptionInfo;
@property (nonatomic, strong) QAConnectOptionInfo *rightSelectedOptionInfo;
@property (nonatomic, copy) SelectedTwinOptionActionBlock selectedActionBlock;

@end

@implementation QAConnectContentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.leftView = [[QAConnectOptionsView alloc]init];
    WEAK_SELF
    [self.leftView setSelectedOptionCellActionBlock:^(QAConnectOptionInfo *optionInfo) {
        STRONG_SELF
        self.leftSelectedOptionInfo = optionInfo;
        [self resetSelectedOPtions];
    }];
    self.rightView = [[QAConnectOptionsView alloc]init];
    [self.rightView setSelectedOptionCellActionBlock:^(QAConnectOptionInfo *optionInfo) {
        STRONG_SELF
        self.rightSelectedOptionInfo = optionInfo;
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

- (void)updateWithLeftOptionArray:(NSMutableArray *)leftArray rightOPtionArray:(NSMutableArray *)rightArray {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected = NO"];
    NSArray *leftOPtionArray = [leftArray filteredArrayUsingPredicate:predicate];
    self.leftOPtionArray = [NSMutableArray arrayWithArray:leftOPtionArray];
    self.leftView.optionInfoArray = self.leftOPtionArray;
    [self.leftView reloadData];
    
    NSArray *rightOPtionArray = [rightArray filteredArrayUsingPredicate:predicate];
    self.rightOptionArray = [NSMutableArray arrayWithArray:rightOPtionArray];
    self.rightView.optionInfoArray = self.rightOptionArray;
    [self.rightView reloadData];
}

- (void)resetSelectedOPtions {
    if (!isEmpty(self.leftSelectedOptionInfo) && !isEmpty(self.rightSelectedOptionInfo)) {
        if ([self.leftOPtionArray containsObject:self.leftSelectedOptionInfo] && [self.rightOptionArray containsObject:self.rightSelectedOptionInfo]) {
            BLOCK_EXEC(self.selectedActionBlock,self.leftSelectedOptionInfo,self.rightSelectedOptionInfo);
            self.leftSelectedOptionInfo = nil;
            self.rightSelectedOptionInfo = nil;
        }
    }
}

-(void)setSelectedTwinOptionActionBlock:(SelectedTwinOptionActionBlock)block {
    self.selectedActionBlock = block;
}
@end
