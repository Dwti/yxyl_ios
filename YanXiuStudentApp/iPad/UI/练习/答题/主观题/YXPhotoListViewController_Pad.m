//
//  YXPhotoListViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXPhotoListViewController_Pad.h"
#import "YXPhotoSelectBottomView.h"
#import "YXAlertView+YXConfirmMethod.h"
#import "YXPhotoCollectionViewCell.h"

@interface YXPhotoListViewController_Pad ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)YXAlbumViewModel * albumViewModel;
@property(nonatomic, strong)UICollectionView * photosListCollectionView;
@property(nonatomic, strong)YXPhotoSelectBottomView* selectBottomView;
@property(nonatomic, assign)BOOL                     scrollDone;
@end
static NSString *identifierCell = @"identifierCell";

@implementation YXPhotoListViewController_Pad

- (instancetype)initWithViewModel:(YXAlbumViewModel *)viewModel
{
    if (self = [super init]) {
        _albumViewModel = viewModel;
        _scrollDone = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftWithImageNamed:@"取消icon" highlightImageNamed:@"取消icon-按下"];
    
    // Do any additional setup after loading the view.
    @weakify(self);
#if 0
    UIBarButtonItem * rigthItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = rigthItem;
    rigthItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        PHOTOMANAGER.photosArray = (NSMutableArray *)self.albumViewModel.currentPhotoListArray;
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        return [RACSignal empty];
    }];
#endif
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 12;
    flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 5);
    flowLayout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 25);
    self.photosListCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero  collectionViewLayout:flowLayout];
    [self.photosListCollectionView registerClass:[YXPhotoCollectionViewCell class] forCellWithReuseIdentifier:identifierCell];
    self.photosListCollectionView.delegate = self;
    self.photosListCollectionView.dataSource = self;
    self.photosListCollectionView.backgroundColor = [UIColor colorWithHexString:@"008080"];
    [self.view addSubview:self.photosListCollectionView];
    
    [self.photosListCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-45);
    }];
    
    self.selectBottomView = [[YXPhotoSelectBottomView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.selectBottomView];
    [self.selectBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(53);
    }];
    self.selectBottomView.doneHandle = ^(){
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        [self.albumViewModel selectPhotoArrayAddObjectWithArray: (NSMutableArray *)self.albumViewModel.currentPhotoListArray];
    };
}

/*
 - (void)viewDidLayoutSubviews
 {
 [super viewDidLayoutSubviews];
 if (!self.scrollDone && [self.albumViewModel.currentPhotoListArray count] > 0) {
 NSIndexPath * indexPath = [NSIndexPath indexPathForItem:[self.albumViewModel.currentPhotoListArray count] - 1 inSection:0];
 [self.photosListCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
 self.scrollDone = YES;
 }
 }
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviLeftAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UICollectionViewDelegates for photos
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.albumViewModel getCurrentPhotoListArrayCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YXPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    [cell sizeToFit];
    YXPhotoModel * model = self.albumViewModel.currentPhotoListArray[indexPath.row];
    cell.photoModel = model;
    @weakify(self);
    cell.selectHandle = ^(YXPhotoModel * yxModel, UIButton * sender){
        @strongify(self);
        if (yxModel.isSelect) {
            yxModel.isSelect = NO;
            sender.selected = NO;
        }else if ([self.albumViewModel isCanSelect]) {
            yxModel.isSelect = YES;
            sender.selected = YES;
        }else{
            NSString *message = [NSString stringWithFormat:@"你最多只能选择%ld张照片",(long)[self.albumViewModel canSelectPhotoCount]];
            [YXAlertView showAlertWithMessage:message hint:@"我知道了"];
        }
        [self.selectBottomView reloadTitleWithInteger:[self.albumViewModel selectCount]];
    };
    [cell remakeFrameWithIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogError(@"%@, %@", @(indexPath.section), @(indexPath.row));
#if 0
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = YES;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    [browser setCurrentPhotoIndex:indexPath.row];
    [self.navigationController pushViewController:browser animated:YES];
#endif
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = (CGRectGetWidth(self.view.frame) - 15 * 9)/8;
    return CGSizeMake(width, width);
    
    //return CGSizeMake((CGRectGetWidth(self.view.frame) - 15 * 4)/3, (CGRectGetWidth(self.view.frame) - 15 * 4)/3);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

@end
