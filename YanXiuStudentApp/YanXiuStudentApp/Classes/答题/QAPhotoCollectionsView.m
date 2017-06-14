//
//  QAPhotoCollectionsView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAPhotoCollectionsView.h"
#import "QAPhotoCollectionCell.h"

@interface QAPhotoCollectionsView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation QAPhotoCollectionsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 90;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[QAPhotoCollectionCell class] forCellReuseIdentifier:@"QAPhotoCollectionCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QAPhotoCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAPhotoCollectionCell"];
    cell.collection = self.collectionArray[indexPath.row];
    cell.isCurrent = indexPath.row==self.currentIndex;
    cell.bottomLineHidden = indexPath.row==self.collectionArray.count-1;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.row;
    [self.tableView reloadData];
    BLOCK_EXEC(self.collectionSelectBlock,self.collectionArray[indexPath.row]);
}

@end
