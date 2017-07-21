//
//  QAKnowledgePointView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAKnowledgePointView.h"
#import "QAKnowledgePointCell.h"
#import "CollectionViewEqualSpaceFlowLayout.h"

@interface QAKnowledgePointView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation QAKnowledgePointView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    CollectionViewEqualSpaceFlowLayout *flowLayout = [[CollectionViewEqualSpaceFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 18;
    flowLayout.minimumLineSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 0, 15, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[QAKnowledgePointCell class] forCellWithReuseIdentifier:@"QAKnowledgePointCell"];
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
    return self.dataArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QAKnowledgePointCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QAKnowledgePointCell" forIndexPath:indexPath];
    cell.knowledgePoint = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *item = self.dataArray[indexPath.row];
    return [QAKnowledgePointCell sizeForTitle:item];
}

- (CGFloat)heightWithDataArray:(NSArray *)dataArray {
    self.dataArray = dataArray;
    [self.collectionView layoutIfNeeded];
    [self.collectionView reloadData];
    return self.collectionView.contentSize.height;
}
@end
