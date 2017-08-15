//
//  QAClassifyPopupView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/11.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAClassifyPopupView.h"
#import "CollectionViewEqualSpaceFlowLayout.h"
#import "QAClassifyOptionCell.h"

@interface QAClassifyPopupView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UIButton *foldButton;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *emptyLabel;
@end

@implementation QAClassifyPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.optionInfoArray = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *circleImageView = [[UIImageView alloc]init];
    circleImageView.image = [UIImage imageNamed:@"篮子绿底"];
    [self addSubview:circleImageView];
    [circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(85, 41));
    }];
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    bgView.layer.cornerRadius = 10;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(circleImageView.mas_bottom);
        make.bottom.mas_equalTo(10);
    }];
    self.foldButton = [[UIButton alloc]init];
    [self.foldButton setBackgroundImage:[UIImage imageNamed:@"页面弹窗的收起按钮正常态"] forState:UIControlStateNormal];
    [self.foldButton setBackgroundImage:[UIImage imageNamed:@"页面弹窗的收起按钮点击态"] forState:UIControlStateHighlighted];
    [self.foldButton addTarget:self action:@selector(foldAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.foldButton];
    [self.foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.foldButton addGestureRecognizer:pan];
    
    self.categoryLabel = [[UILabel alloc]init];
    self.categoryLabel.font = [UIFont boldSystemFontOfSize:19];
    self.categoryLabel.textColor = [UIColor colorWithHexString:@"69ad0a"];
    self.categoryLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:self.categoryLabel];
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(5+18);
        make.right.mas_equalTo(-18);
    }];
    
    CollectionViewEqualSpaceFlowLayout *layout = [[CollectionViewEqualSpaceFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.directionalLockEnabled = YES;
    self.collectionView.allowsMultipleSelection = YES;
    [bgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.categoryLabel.mas_bottom).mas_offset(18);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];

    self.emptyLabel = [[UILabel alloc]init];
    self.emptyLabel.text = @"当前类别下内容为空";
    self.emptyLabel.font = [UIFont boldSystemFontOfSize:27];
    self.emptyLabel.textColor = [UIColor colorWithHexString:@"69ad0a"];
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.emptyLabel];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (void)foldAction {
    BLOCK_EXEC(self.foldBlock);
}

- (void)panAction:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        BLOCK_EXEC(self.foldBlock);
        return;
    }
    CGPoint translation = [gesture translationInView:gesture.view];
    if (translation.y > 0) {
        BLOCK_EXEC(self.dragDownBlock,translation.y);
    }
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

- (void)setOptionInfoArray:(NSMutableArray<QAClassifyOptionInfo *> *)optionInfoArray {
    _optionInfoArray = optionInfoArray;
    self.emptyLabel.hidden = optionInfoArray.count!=0;
    if (optionInfoArray.count > 0) {
        QAClassifyOptionCell *cell = [QAClassifyOptionCell cellWithOption:optionInfoArray.firstObject.option];
        [self.collectionView registerClass:[cell class] forCellWithReuseIdentifier:@"OptionCell"];
    }
    [self.collectionView reloadData];
}

- (void)setCategoryName:(NSString *)categoryName {
    _categoryName = categoryName;
    self.categoryLabel.text = categoryName;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.optionInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QAClassifyOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OptionCell" forIndexPath:indexPath];
    WEAK_SELF
    [cell setSizeChangedBlock:^(CGSize size){
        STRONG_SELF
        if (!CGSizeEqualToSize(size, self.optionInfoArray[indexPath.row].size)){
            self.optionInfoArray[indexPath.row].size = size;
            [UIView performWithoutAnimation:^{
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
        }
    }];
    [cell setDeleteBlock:^{
        STRONG_SELF
        QAClassifyOptionInfo *info = [self.optionInfoArray objectAtIndex:indexPath.row];
        [self.optionInfoArray removeObject:info];
        [self.collectionView reloadData];
        self.emptyLabel.hidden = self.optionInfoArray.count!=0;
        BLOCK_EXEC(self.deleteBlock,info);
    }];
    cell.optionString = self.optionInfoArray[indexPath.row].option;
    cell.canDelete = YES;
    cell.selected = self.optionInfoArray[indexPath.row].selected;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.optionInfoArray[indexPath.row].size;
}

@end
