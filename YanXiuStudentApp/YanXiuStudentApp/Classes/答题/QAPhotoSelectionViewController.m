//
//  QAPhotoSelectionViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAPhotoSelectionViewController.h"
#import "QAPhotoSelectionCell.h"
#import "QAPhotoSelectionTitleView.h"
#import "QAPhotoCollectionsView.h"
#import "QAPhotoClipViewController.h"

@interface QAPhotoSelectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) QAPhotoSelectionTitleView *titleView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) QAPhotoCollectionsView *photoCollectionsView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) NSMutableArray *collectionArray;
@property (nonatomic, strong) NSMutableArray *assetArray;
@property (nonatomic, strong) PHAssetCollection *currentCollection;
@end

@implementation QAPhotoSelectionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadCollections];
    self.currentCollection = self.collectionArray.firstObject;
    [self loadAssetsFromCollection:self.currentCollection];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.naviTheme = NavigationBarTheme_White;
    WEAK_SELF
    [self nyx_setupLeftWithImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 26, 26)] action:^{
        STRONG_SELF
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    self.titleView = [[QAPhotoSelectionTitleView alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
    self.titleView.title = self.currentCollection.localizedTitle;
    [self.titleView setStatusChangedBlock:^{
        STRONG_SELF
        self.titleView.isFold = !self.titleView.isFold;
        if (self.titleView.isFold) {
            [self hideCollectionsView];
        }else {
            [self showCollectionsView];
        }
    }];
    self.navigationItem.titleView = self.titleView;
    [self setupUI];
}

- (void)showCollectionsView {
    [self.view addSubview:self.maskView];
    [self.view bringSubviewToFront:self.photoCollectionsView];
    [UIView animateWithDuration:0.3 animations:^{
        self.photoCollectionsView.frame = CGRectMake(0, 0, self.photoCollectionsView.width, self.photoCollectionsView.height);
    }completion:^(BOOL finished) {
        
    }];
}

- (void)hideCollectionsView {
    [UIView animateWithDuration:0.3 animations:^{
        self.photoCollectionsView.frame = CGRectMake(0, -self.photoCollectionsView.height, self.photoCollectionsView.width, self.photoCollectionsView.height);
    }completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
    }];
}

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
    CGFloat width = (self.view.width-3*4)/3;
    layout.itemSize = CGSizeMake(width, width);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[QAPhotoSelectionCell class] forCellWithReuseIdentifier:@"QAPhotoSelectionCell"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    self.maskView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    CGFloat height = MIN(self.collectionArray.count*90, SCREEN_HEIGHT-55);
    self.photoCollectionsView = [[QAPhotoCollectionsView alloc]initWithFrame:CGRectMake(0, -height, self.view.width, height)];
    self.photoCollectionsView.collectionArray = self.collectionArray;
    WEAK_SELF
    [self.photoCollectionsView setCollectionSelectBlock:^(PHAssetCollection *collection){
        STRONG_SELF
        self.titleView.isFold = YES;
        [self hideCollectionsView];
        if (collection == self.currentCollection) {
            return;
        }
        self.titleView.title = collection.localizedTitle;
        [self loadAssetsFromCollection:collection];
        [self.collectionView reloadData];
    }];
    [self.view addSubview:self.photoCollectionsView];
}

- (void)loadCollections {
    self.collectionArray = [NSMutableArray array];
    PHFetchResult *results = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in results) {
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
            [self.collectionArray insertObject:collection atIndex:0];
        }else if (collection.assetCollectionSubtype!=PHAssetCollectionSubtypeSmartAlbumVideos && collection.assetCollectionSubtype!=PHAssetCollectionSubtypeSmartAlbumSlomoVideos) {
            [self.collectionArray addObject:collection];
        }
    }
    results = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in results) {
        [self.collectionArray addObject:collection];
    }
}

- (void)loadAssetsFromCollection:(PHAssetCollection *)collection {
    self.assetArray = [NSMutableArray array];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    for (PHAsset *asset in assetsFetchResults) {
        QAPhotoItem *item = [[QAPhotoItem alloc]init];
        item.asset = asset;
        [self.assetArray addObject:item];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QAPhotoSelectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QAPhotoSelectionCell" forIndexPath:indexPath];
    QAPhotoItem *item = self.assetArray[indexPath.row];
    cell.photoItem = item;
    WEAK_SELF
    [cell setClickBlock:^{
        STRONG_SELF
        [self requestImageFromAsset:item.asset];
    }];
    return cell;
}

- (void)requestImageFromAsset:(PHAsset *)asset {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    WEAK_SELF
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        STRONG_SELF
        [self gotoClipVCWithImage:result];
    }];
}

- (void)gotoClipVCWithImage:(UIImage *)image {
    QAPhotoClipViewController *vc = [[QAPhotoClipViewController alloc]init];
    vc.oriImage = image;
    WEAK_SELF
    [vc setClippedBlock:^(UIImage *clippedImage){
        STRONG_SELF
//        [self dismissViewControllerAnimated:NO completion:nil];
        BLOCK_EXEC(self.clippedImageBlock,clippedImage);
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
