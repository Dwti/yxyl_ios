//
//  YXAlbumListViewController.m
//  ImagePickerDemo
//
//  Created by wd on 15/9/17.
//  Copyright (c) 2015年 wd. All rights reserved.
//

#import "YXAlbumListViewController.h"
#import "YXAlbumViewModel.h"
#import "YXPhotoListViewController.h"
#import "PhotoAssetUtils.h"

@interface YXAlbumListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) YXAlbumViewModel *albumViewModel;
@property (nonatomic, strong) UITableView *albumListTableView;
@property (nonatomic, copy) NSArray *albumArray;
@end

@implementation YXAlbumListViewController

- (instancetype)initWithViewModel:(YXAlbumViewModel *)viewModel {
    if (self = [super init]) {
        _albumViewModel = viewModel;
    }
    return self;
}

- (instancetype)initWithAlbumArray:(NSArray *)albumArray {
    if (self = [super init]) {
        self.albumArray = albumArray;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViews];
    [self setupViewModel];
}

- (void)setupViews {
    //TODO
    @weakify(self);
    UIBarButtonItem * rigthItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = rigthItem;
    rigthItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        return [RACSignal empty];
    }];
    
    self.albumListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.albumListTableView.backgroundColor = [UIColor clearColor];
    self.albumListTableView.delegate = self;
    self.albumListTableView.dataSource = self;
    self.albumListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.albumListTableView];
    [self.albumListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
}

- (void)setupViewModel {
    //[self.albumViewModel gotoGetAlbumListArray];
}

#pragma mark --UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [self.albumViewModel albumListArrayCount];
    return [self.albumArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierCell = @"identifierCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView.mas_bottom);
            make.left.equalTo(cell);
            make.right.equalTo(cell);
            make.height.mas_equalTo(0.5);
        }];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    NSDictionary * dict = [self.albumViewModel getAlbumInfo:indexPath.row];
//    cell.imageView.image = [dict objectForKey:@"thumbnail"];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",[dict objectForKey:@"name"],[dict objectForKey:@"count"]];

    
    AssetGroupInfo *info = [PhotoAssetUtils assetGroupInfoFromGroup:self.albumArray[indexPath.row]];
    cell.imageView.image = info.thumbnail;
    cell.textLabel.text = info.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [self.albumViewModel pushToPhotoListViewByIndex:indexPath.row];
    //YXPhotoListViewController * viewController = [[YXPhotoListViewController alloc] initWithViewModel:self.albumViewModel];
    
    NSArray *photoArray = [PhotoAssetUtils allPhotosFromAssetGroup:self.albumArray[indexPath.row]];
    AssetGroupInfo *info = [PhotoAssetUtils assetGroupInfoFromGroup:self.albumArray[indexPath.row]];

    YXPhotoListViewController *vc = [[YXPhotoListViewController alloc]  initWithPhotoArray:photoArray];
    //NSDictionary * dict = [self.albumViewModel getAlbumInfo:indexPath.row];
    //viewController.title = [dict objectForKey:@"name"];
    vc.title = info.name;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
