//
//  MistakeQuestionSheetView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MistakeQuestionSheetView.h"
#import "UIButton+WaveHighlight.h"

static const CGFloat kItemWidth = 60;
static const CGFloat kMinMargin = 15;

@interface MistakeQuestionSheetView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *stateArray;
@property (nonatomic, strong) NSArray *questionArray;
@end


@implementation MistakeQuestionSheetView

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
    [self.collectionView registerClass:[MistakeQuestionItemCell class] forCellWithReuseIdentifier:@"MistakeQuestionItemCell"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
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
    MistakeQuestionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MistakeQuestionItemCell" forIndexPath:indexPath];
    cell.hasWrote = [self.stateArray[indexPath.item] boolValue];
    cell.item = self.questionArray[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kItemWidth, kItemWidth);
}

- (void)setModel:(QAPaperModel *)model{
    _model = model;
    
    self.questionArray = self.model.questions;
    
    self.stateArray = [NSMutableArray array];
    [self.questionArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAQuestion *item = (QAQuestion *)obj;
        BOOL hasAnswer = [item hasAnswered:item];
        [self.stateArray addObject:@(hasAnswer)];
    }];
    
    [self.collectionView reloadData];
}

@end

