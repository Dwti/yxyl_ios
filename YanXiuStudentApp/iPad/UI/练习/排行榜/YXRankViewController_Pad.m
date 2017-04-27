//
//  YXRankViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXRankViewController_Pad.h"
#import "YXRankModel.h"
#import "YXRankRequest.h"
#import "YXRankViewCell_Pad.h"
#import "YXRankHeaderView_Pad.h"
#import "YXCommonErrorView.h"

@interface YXRankViewController_Pad ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YXRankModel *rankModel;
@property (nonatomic, strong) YXRankRequest *rankRequest;
@property (nonatomic, strong) YXCommonErrorView *errorView;

@end

@implementation YXRankViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"排行榜背景"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIImage *rankImage = [UIImage imageNamed:@"奖杯"];
    UIImageView *rankBGView = [[UIImageView alloc] initWithImage:rankImage];
    [self.view addSubview:rankBGView];
    [rankBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(rankImage.size.height * 800 / rankImage.size.width);
    }];
    
    UIImageView *tableViewBGView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"容器背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    tableViewBGView.userInteractionEnabled = YES;
    tableViewBGView.clipsToBounds = YES;
    [self.view addSubview:tableViewBGView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(325.f, 104.f);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical = YES;
    [_collectionView registerClass:[YXRankViewCell_Pad class] forCellWithReuseIdentifier:@"YXRankViewCell_Pad"];
    [_collectionView registerClass:[YXRankHeaderView_Pad class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YXRankHeaderView_Pad"];
    [tableViewBGView addSubview:_collectionView];
    
    UIImageView *rankIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"排行榜icon"]];
    [self.view addSubview:rankIconView];
    [rankIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(102);
        make.width.mas_equalTo(235);
    }];
    [tableViewBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rankIconView.mas_top).offset(78);
        make.left.mas_equalTo(75);
        make.right.mas_equalTo(-75);
        make.bottom.mas_equalTo(-50);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(7);
        make.right.mas_equalTo(-7);
        make.bottom.mas_equalTo(-3);
    }];
    
    _errorView = [[YXCommonErrorView alloc] init];
    _errorView.hidden = YES;
    @weakify(self);
    [_errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        [self requestRankList];
    }];
    [tableViewBGView addSubview:_errorView];
    [_errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self requestRankList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)requestRankList
{
    self.rankModel = nil;
    [self.collectionView reloadData];
    [self.rankRequest stopRequest];
    self.rankRequest = [[YXRankRequest alloc] init];
    [self yx_startLoading];
    @weakify(self);
    [self.rankRequest startRequestWithRetClass:[YXRankRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        self.errorView.hidden = YES;
        self.collectionView.hidden = NO;
        if (error) {
            self.errorView.hidden = NO;
            self.collectionView.hidden = YES;
            return;
        }
        YXRankRequestItem *item = (YXRankRequestItem *)retItem;
        if (item.data.count == 0) {
            [self yx_showToast:@"暂无数据"];
            return;
        }
        self.rankModel = [YXRankModel rankModelFromRankRequestItem:item];
        [self.collectionView reloadData];
    }];
}

- (void)reloadUI {
    if (self.errorView) {
        [self requestRankList];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.rankModel.rankItemArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YXRankViewCell_Pad *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXRankViewCell_Pad" forIndexPath:indexPath];
    cell.rankItem = self.rankModel.rankItemArray[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    YXRankHeaderView_Pad *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YXRankHeaderView_Pad" forIndexPath:indexPath];
    headerView.rank = self.rankModel.myRank;
    return headerView;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(self.view.bounds), 45.f);
}

@end
