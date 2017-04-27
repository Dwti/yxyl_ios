//
//  PhotoListViewController.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/30/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "PhotoListViewController.h"
#import "YXBarButtonItemCustomView.h"
#import "YXPhotoManager.h"
#import "PhotoAssetManager.h"
#import "AlbumListView.h"
#import "PhotoAssetUtils.h"
#import "PhotoCollectionViewCell.h"
#import "YXBarButtonItemCustomView.h"
#import "ChooseAlbumListButton.h"
#import "YXBottomGradientView.h"

static NSString *identifierCell = @"identifierCell";

@interface PhotoListViewController () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, assign) BOOL isShowingAlbumList;
@property (nonatomic, copy) NSArray *albumListArray;
@property (nonatomic, copy) NSArray *photoArray;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UICollectionView *photoListCollectionView;
@property (nonatomic, strong) AlbumListView *albumListView;
@property (nonatomic, strong) ChooseAlbumListButton *albumListButton;
@property (nonatomic, strong) YXBottomGradientView *gradientView;

@end

@implementation PhotoListViewController

- (instancetype)initWithAlbumArray:(NSArray *)albumArray {
    if (self = [super init]) {
        self.albumListArray = albumArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setupUI {
    [self setupData];
    [self setupCloseBarButton];
    [self setupPhotoListCollectionView];
    [self setupToolBar];
    [self setupAlbumListView];
}

- (void)setupData {
    AssetGroupInfo *info = [PhotoAssetUtils assetGroupInfoFromGroup:self.albumListArray.firstObject];
    self.title = info.name;
    WEAK_SELF
    [[PhotoAssetManager shareManager] getPhotoListOfGroup:self.albumListArray.firstObject result:^(NSArray *resultArray) {
        STRONG_SELF
        self.photoArray = resultArray;
    }];
}

- (void)setupCloseBarButton {
    YXBarButtonItemCustomView *customView = [[YXBarButtonItemCustomView alloc] init];
    [customView setButtonTitle:@"" image:[UIImage imageNamed:@"返回icon"] highLightedImage:[UIImage imageNamed:@"返回icon-按下"] isRight:NO];
    [customView.button addTarget:self action:@selector(backBarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, barButtonItem];
}

- (void)setupPhotoListCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 12;
    flowLayout.headerReferenceSize = CGSizeMake(self.view.width, 5);
    flowLayout.footerReferenceSize = CGSizeMake(self.view.width, 25);
    
    self.photoListCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.photoListCollectionView.delegate = self;
    self.photoListCollectionView.dataSource = self;
    self.photoListCollectionView.backgroundColor = [UIColor colorWithHexString:@"008080"];
    [self.photoListCollectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:identifierCell];
}

- (void)setupToolBar {
    self.toolBar = [[UIView alloc] init];
    self.toolBar.backgroundColor = [UIColor colorWithHexString:@"393a3f"];
    
    self.albumListButton = [[ChooseAlbumListButton alloc] init];
    self.albumListButton.bExpand = NO;
    [self.albumListButton updateWithTitle:self.title];
    WEAK_SELF
    [[self.albumListButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.isShowingAlbumList) {
            [self hideAlbumListView];
        } else {
            [self showAlbumListView];
        }
    }];
    
    self.gradientView = [[YXBottomGradientView alloc] initWithFrame:CGRectZero color:[UIColor colorWithHexString:@"008080"]];
}

- (void)setupAlbumListView {
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [UIColor clearColor];
    self.maskView.hidden = YES;
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAlbumListView)];
    [self.maskView addGestureRecognizer:tap];
    
    self.albumListView = [[AlbumListView alloc] initWithAlbumList:self.albumListArray];
    WEAK_SELF
    [self.albumListView setAlbumSelectBlock:^(NSInteger index) {
        STRONG_SELF
        [self hideAlbumListView];
        
        AssetGroupInfo *info = [PhotoAssetUtils assetGroupInfoFromGroup:self.albumListArray[index]];
        self.title = info.name;
        [self.albumListButton updateWithTitle:self.title];
        
        [[PhotoAssetManager shareManager] getPhotoListOfGroup:self.albumListArray[index] result:^(NSArray *resultArray) {
            self.photoArray = resultArray;
        }];
        [self.photoListCollectionView reloadData];
    }];
    
    self.isShowingAlbumList = NO;
}

- (void)setupLayout {
    [self.view addSubview:self.photoListCollectionView];
    [self.photoListCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-60);
    }];
    
    [self.view addSubview:self.gradientView];
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-60);
        make.height.mas_equalTo(30);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.photoListCollectionView.mas_bottom).offset(0);
    }];
    
    [self.toolBar addSubview:self.albumListButton];
    [self.albumListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(28);
        make.top.mas_equalTo(20);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.view addSubview:self.albumListView];
    [self.albumListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-60);
        make.height.mas_equalTo(0);
    }];
}

#pragma mark - Actions
- (void)showAlbumListView {
    self.albumListButton.bExpand = !self.albumListButton.bExpand;
    self.isShowingAlbumList = YES;
    self.maskView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.albumListView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-60);
            make.top.mas_offset(120);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)hideAlbumListView {
    self.albumListButton.bExpand = !self.albumListButton.bExpand;
    self.isShowingAlbumList = NO;
    self.maskView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.albumListView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-60);
            make.height.mas_equalTo(0);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)backBarButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.photoAsset = self.photoArray[indexPath.row];
    
    WEAK_SELF
    [cell setSelectHandle:^(UIImage *img) {
        STRONG_SELF
        self.photoDidSelectBlock(img);
    }];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.view.width - 15 * 4) / 3;
    return CGSizeMake(width, width);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 0, 15);
}

@end
