//
//  BCTopicFilterView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BCTopicFilterView.h"
#import "BCTopicAlphabeticallyButton.h"
#import "BCTopicAnswerstateButton.h"
#import "BCTopicAnswerStateFilterView.h"
#import "AlertView.h"

@interface BCTopicFilterView ()
@property(nonatomic, strong) BCTopicAlphabeticallyButton *alphabeticallyButton;
@property(nonatomic, strong) UIButton *popularityRankButton;
@property(nonatomic, strong) BCTopicAnswerstateButton *answerstateButton;
@property(nonatomic, strong) BCTopicAnswerStateFilterView *selectionView;
@property(nonatomic, strong) AlertView *alertView;

@property(nonatomic, assign) CGFloat itemWidth;

@property(nonatomic, copy) AlphabeticallyBlock alphabeticallyActionBlock;
@property(nonatomic, copy) PopularityRankBlock popularityRankActionBlock;
@property(nonatomic, copy) AnswerstateFilterBlock answerstateActionBlock;
@end

@implementation BCTopicFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.itemWidth = SCREEN_WIDTH / 3;
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.alphabeticallyButton = [[BCTopicAlphabeticallyButton alloc]init];
    [self.alphabeticallyButton addTarget:self action:@selector(alphabeticallyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.alphabeticallyButton];
    [self.alphabeticallyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.itemWidth);
        make.centerY.mas_equalTo(0);
    }];
    
    UIView *firstLine = [[UIView alloc]init];
    firstLine.backgroundColor = [UIColor colorWithHexString:@"e1e3e0"];
    [self addSubview:firstLine];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.itemWidth - 1.f);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(2.f);
        make.height.mas_equalTo(17.f);
    }];
    
    self.popularityRankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.popularityRankButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [self.popularityRankButton setTitle:@"人气排序" forState:UIControlStateNormal];
    [self.popularityRankButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.popularityRankButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateSelected];
    [self.popularityRankButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateHighlighted];
    [self.popularityRankButton addTarget:self action:@selector(popularityRankButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.popularityRankButton];
    [self.popularityRankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(self.itemWidth);
    }];
    
    UIView *secondLine = [[UIView alloc]init];
    secondLine.backgroundColor = [UIColor colorWithHexString:@"e1e3e0"];
    [self addSubview:secondLine];
    [secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo( 2 * self.itemWidth - 1.f);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(2.f);
        make.height.mas_equalTo(17.f);
    }];
    
    self.answerstateButton = [[BCTopicAnswerstateButton alloc]init];
    [self.answerstateButton addTarget:self action:@selector(answerstateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.answerstateButton];
    [self.answerstateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(self.itemWidth);
    }];
    
    self.selectionView = [[BCTopicAnswerStateFilterView alloc]init];
    self.selectionView.selectedRow = 0;
}

- (void)alphabeticallyButtonAction:(BCTopicAlphabeticallyButton *)sender {
    self.popularityRankButton.selected = NO;
    self.answerstateButton.isFilter = NO;
    if (!self.alphabeticallyButton.isFilter) {
        self.alphabeticallyButton.isFilter = YES;
    }
    self.alphabeticallyButton.isPositiveSequence = !self.alphabeticallyButton.isPositiveSequence;
    BLOCK_EXEC(self.alphabeticallyActionBlock,self.alphabeticallyButton.isFilter,self.alphabeticallyButton.isPositiveSequence);
}

- (void)popularityRankButtonAction:(UIButton *)sender {
    self.alphabeticallyButton.isFilter = NO;
    self.popularityRankButton.selected = YES;
    self.answerstateButton.isFilter = NO;
    BLOCK_EXEC(self.popularityRankActionBlock,self.popularityRankButton.selected);
}

- (void)answerstateButtonAction:(UIButton *)sender {
    [self showAnswerStateFilterView];
    self.answerstateButton.isFilter = YES;
}

- (void)setAnswerStateTitle:(NSString *)answerStateTitle {
    _answerStateTitle = answerStateTitle;
    if (self.answerstateButton.selected == NO && answerStateTitle.length == 0) {
        self.answerstateButton.selected = NO;
    }else {
        self.answerstateButton.selected = YES;
        self.answerstateButton.title = answerStateTitle;
    }
    self.answerstateButton.isFilter = NO;
}

- (void)setAlphabeticallyBlock:(AlphabeticallyBlock)block {
    self.alphabeticallyActionBlock = block;
}

- (void)setPopularityRankBlock:(PopularityRankBlock)block {
    self.popularityRankActionBlock = block;
}

- (void)setAnswerstateFilterBlock:(AnswerstateFilterBlock)block {
    self.answerstateActionBlock = block;
}


- (void)showAnswerStateFilterView {
    if (self.alertView.superview) {
        return;
    }
    
    BCTopicAnswerStateFilterView *selectionView = self.selectionView;
    AlertView *alert = [[AlertView alloc]init];
    alert.hideWhenMaskClicked = YES;
    alert.contentView = selectionView;
    self.alertView = alert;
    CGFloat selectionViewHeight = 150.f;
    WEAK_SELF
      [alert setHideBlock:^(AlertView *view) {
        STRONG_SELF
          [self hideSelectionView];
    }];
    [alert showInView:self.superview withLayout:^(AlertView *view) {
        STRONG_SELF
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(55.f);
            make.left.right.bottom.mas_equalTo(0);
        }];
        [selectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.bottom.equalTo(view.mas_top).offset(0);
        }];
        [view layoutIfNeeded];
        [UIView animateWithDuration:0.3f animations:^{
            [selectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(view);
                make.top.equalTo(view.mas_top).offset(0);
                make.height.mas_equalTo(selectionViewHeight);
            }];
            [view layoutIfNeeded];
        }];
    }];
    [selectionView setAnswerStateFilterCompletedBlock:^(NSString *selectedTitle, NSInteger selectedRow) {
        STRONG_SELF
        [alert hide];
        //按选中的进行筛选
        if (self.answerstateButton.selected == NO && selectedTitle.length == 0) {
            self.answerstateButton.selected = NO;
        }else {
            self.answerstateButton.selected = YES;
            self.answerstateButton.title = selectedTitle;
        }
        self.answerstateButton.isFilter = NO;
        // //可能需要存储起来供接口筛选
        BLOCK_EXEC(self.answerstateActionBlock,[NSString stringWithFormat:@"%@",@(selectedRow)]);
    }];
    
}

- (void)answerStateFilterAbort {
    if (self.alertView.superview) {
        [self hideSelectionView];
    }
}

- (void)hideSelectionView {
    [UIView animateWithDuration:0.3 animations:^{
        [self.selectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.alertView);
            make.bottom.equalTo(self.alertView.mas_top).offset(0);
        }];
        [self.alertView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.alertView removeFromSuperview];
        self.answerstateButton.isFilter = NO;
    }];
}
@end
