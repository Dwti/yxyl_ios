//
//  TextbookVersionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/25.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "TextbookVersionView.h"
#import "TextbookVersionCell.h"

static const CGFloat kItemWidth = 86.f;
static const CGFloat kItemHeight = 141.f;
static const CGFloat kMinMargin = 15.f;

@interface TextbookVersionView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) ChooseVersionActionBlock chooseBlock;

@end

@implementation TextbookVersionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = kMinMargin;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    if (SCREEN_WIDTH > 375) {
        layout.sectionInset = UIEdgeInsetsMake(40, 45 * kPhoneWidthRatio, 40, 45 * kPhoneWidthRatio);
    }else {
        layout.sectionInset = UIEdgeInsetsMake(30, 30 * kPhoneWidthRatio, 30, 30 * kPhoneWidthRatio);
    }
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[TextbookVersionCell class] forCellWithReuseIdentifier:@"TextbookVersionCell"];
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
    return self.item.subjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TextbookVersionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TextbookVersionCell" forIndexPath:indexPath];
    GetSubjectRequestItem_subject *subject = self.item.subjects[indexPath.item];
    cell.subject = subject;
    if (!subject.edition) {
        cell.hasChoosedEdition = NO;
    }else {
        cell.hasChoosedEdition = YES;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kItemWidth, kItemHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TextbookVersionCell *cell = (TextbookVersionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    BLOCK_EXEC(self.chooseBlock,self.item.subjects[indexPath.item],cell.hasChoosedEdition);
}

-(void)setChooseVersionActionBlock:(ChooseVersionActionBlock)block {
    self.chooseBlock = block;
}

- (void)setItem:(GetSubjectRequestItem *)item {
    _item = item;
    [self.collectionView reloadData];
}
@end
