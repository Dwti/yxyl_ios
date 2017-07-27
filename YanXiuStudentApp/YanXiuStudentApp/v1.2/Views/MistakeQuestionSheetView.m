//
//  MistakeQuestionSheetView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MistakeQuestionSheetView.h"
#import "MistakeQuestionItemCell.h"
#import "MistakeQuestionHeaderView.h"

@interface MistakeQuestionSheetView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation MistakeQuestionSheetView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"fff0b2"];
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor colorWithHexString:@"ffe580"];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(46);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"取消icon"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"取消icon-按下"] forState:UIControlStateHighlighted];
    [topView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    WEAK_SELF
    [[cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.cancelBlock);
    }];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor colorWithHexString:@"805500"];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"题号";
    [topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
//    YXQADashLineView *dash = [[YXQADashLineView alloc]init];
//    dash.color = [UIColor colorWithHexString:@"e6bb47"];
//    [self addSubview:dash];
//    [dash mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//        make.top.mas_equalTo(topView.mas_bottom);
//    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 25;
    layout.itemSize = CGSizeMake(45, 45);
    CGFloat space = floorf(([UIScreen mainScreen].bounds.size.width-45*5)/6);
    layout.minimumInteritemSpacing = space;
    layout.sectionInset = UIEdgeInsetsMake(25, space, 25, space);
    layout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 20);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.collectionView registerClass:[MistakeQuestionItemCell class] forCellWithReuseIdentifier:@"MistakeQuestionItemCell"];
    [self.collectionView registerClass:[MistakeQuestionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MistakeQuestionHeaderView"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
//        make.top.mas_equalTo(dash.mas_bottom);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.item.data.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    MistakeRedoCatalogRequestItem_data *data = self.item.data[section];
    return data.wqnumbers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MistakeQuestionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MistakeQuestionItemCell" forIndexPath:indexPath];
    MistakeRedoCatalogRequestItem_data *data = self.item.data[indexPath.section];
    NSNumber *number = data.wqnumbers[indexPath.row];
    cell.item = self.model.questions[number.integerValue-1];
    WEAK_SELF
    [cell setClickBlock:^(MistakeQuestionItemCell *itemCell) {
        STRONG_SELF
        BLOCK_EXEC(self.selectBlock,itemCell.item);
    }];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        MistakeQuestionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MistakeQuestionHeaderView" forIndexPath:indexPath];
        MistakeRedoCatalogRequestItem_data *data = self.item.data[indexPath.section];
        headerView.title = data.date;
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

@end
