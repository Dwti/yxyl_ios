//
//  AlbumListView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/30/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "AlbumListView.h"
#import "PhotoAssetUtils.h"
#import "PhotoListViewController.h"
#import "AlbumListTableViewCell.h"

static NSString *identifierCell = @"identifierCell";

@interface AlbumListView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *albumListArray;
@property (nonatomic, strong) UITableView *albumListTableView;
@property (nonatomic, strong) NSMutableArray *cellModels;
@property (nonatomic, assign) NSInteger lastSelectedIndex;
@end

@implementation AlbumListView

- (instancetype)initWithAlbumList:(NSArray *)albumArray {
    if (self = [super init]) {
        self.albumListArray = albumArray;
        [self setupCellModel];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.albumListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.albumListTableView.backgroundColor = [UIColor whiteColor];
    self.albumListTableView.delegate = self;
    self.albumListTableView.dataSource =self;
    self.albumListTableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:self.albumListTableView];
    [self.albumListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.albumListTableView registerClass:[AlbumListTableViewCell class] forCellReuseIdentifier:identifierCell];
}

- (void)setupCellModel {
    self.cellModels = [NSMutableArray array];
    self.lastSelectedIndex = 0 ;
    [self.albumListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AlbumListModel *model = [[AlbumListModel alloc] init];
        model.assetInfo = [PhotoAssetUtils assetGroupInfoFromGroup:obj];
        model.isSelected = idx == 0 ? YES : NO;
        
        [self.cellModels addObject:model];
    }];
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];

    cell.model = self.cellModels[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    self.albumSelectBlock(indexPath.row);
    
    if (self.lastSelectedIndex != indexPath.row) {
        AlbumListModel *lastSelectedModel = self.cellModels[self.lastSelectedIndex];
        lastSelectedModel.isSelected = NO;
        
        AlbumListModel *currentSelectedModel = self.cellModels[indexPath.row];
        currentSelectedModel.isSelected = YES;
        
        [tableView reloadData];
        
        self.lastSelectedIndex = indexPath.row;
    }
}

@end
