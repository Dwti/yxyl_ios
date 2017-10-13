//
//  QAAnswerSheetView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnswerSheetView.h"
#import "QAAnswerSheetCell.h"
#import "UIButton+WaveHighlight.h"

static const CGFloat kItemWidth = 60;
static const CGFloat kMinMargin = 15;
static const CGFloat kBottomViewHeight = 45.0f;

@interface QAAnswerSheetView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) SubmitActionBlock buttonActionBlock;
@property (nonatomic, strong) NSMutableArray *stateArray;
@property (nonatomic, strong) NSArray *questionArray;
@end


@implementation QAAnswerSheetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 15;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat width = kItemWidth + kMinMargin;
    NSInteger count = (SCREEN_WIDTH - kMinMargin)/width;
    CGFloat margin = (SCREEN_WIDTH - count * kItemWidth )/(count + 1);
    layout.sectionInset = UIEdgeInsetsMake(20, margin, 20, margin);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 75, 0);
    [self.collectionView registerClass:[QAAnswerSheetCell class] forCellWithReuseIdentifier:@"QAAnswerSheetCell"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.92];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(kBottomViewHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    UIButton *submitButton = [[UIButton alloc]init];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    submitButton.layer.cornerRadius = 6.0f;
    submitButton.clipsToBounds = YES;
    submitButton.isWaveHighlight = YES;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"提交作业" forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"69ad0a"]] forState:UIControlStateHighlighted];
    [submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(170 *kPhoneWidthRatio);
        make.bottom.mas_equalTo(-5);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.questionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QAAnswerSheetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QAAnswerSheetCell" forIndexPath:indexPath];
    cell.hasWrote = [self.stateArray[indexPath.row] boolValue];
    cell.item = self.questionArray[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kItemWidth, kItemWidth);
}


- (void)submitAction:(UIButton *)sender {
    BLOCK_EXEC(self.buttonActionBlock);
}

#pragma mark - setter
- (void)setSubmitActionBlock:(SubmitActionBlock)block {
    self.buttonActionBlock = block;
}

- (void)setModel:(QAPaperModel *)model{
    _model = model;
    
    self.questionArray = [self.model allQuestions];
    
    self.stateArray = [NSMutableArray array];
    [self.questionArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAQuestion *item = (QAQuestion *)obj;
        BOOL hasAnswer = [self hasAnswered:item];
        [self.stateArray addObject:@(hasAnswer)];
    }];
    
    [self.collectionView reloadData];
}

- (BOOL)hasAnswered:(QAQuestion *)data {
    YXQAAnswerState state = [data answerState];
    if (state == YXAnswerStateCorrect ||
        state == YXAnswerStateWrong ||
        state == YXAnswerStateAnswered) {
        return YES;
    }
    return NO;
}
@end
