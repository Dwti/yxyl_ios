//
//  QAConnectSelectedView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAConnectSelectedView.h"
#import "QAConnectSelectedCell.h"
#import "QAConnectOptionInfo.h"
#import "UIImage+Color.h"

@interface QAConnectSelectedView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *circleImageView;
@property (nonatomic, strong) UIImageView *graycircleView;
@property (nonatomic, strong) UIButton *foldButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, strong) UIButton *deleteAllButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellHeightArray;

@property (nonatomic, copy) FoldActionBlock foldBlock;
@property (nonatomic, copy) DeleteActionBlock deleteBlock;
@property (nonatomic, copy) DeleteAllActionBlock deleteAllBlock;

@end


@implementation QAConnectSelectedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.optionInfoArray = [NSMutableArray array];
        [self setupUI];
        [self setupLayout];
        self.isFold = YES;
    }
    return self;
}

- (void)setupUI {
    self.graycircleView = [[UIImageView alloc]init];
    self.graycircleView.image = [UIImage imageNamed:@"灰底"];
   
    self.circleImageView = [[UIImageView alloc]init];
    self.circleImageView.image = [UIImage imageNamed:@"绿"];

    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    self.bgView.layer.cornerRadius = 10;
    
    self.foldButton = [[UIButton alloc]init];
    [self.foldButton setBackgroundImage:[UIImage imageNamed:@"连线题篮子正常态"] forState:UIControlStateNormal];
    [self.foldButton setBackgroundImage:[UIImage imageNamed:@"连线题篮子正常态"] forState:UIControlStateHighlighted];
    [self.foldButton addTarget:self action:@selector(foldAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"69ad0a"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"已连线小题";
    
    self.deleteAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteAllButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    self.deleteAllButton.layer.cornerRadius = 6.f;
    self.deleteAllButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.deleteAllButton.layer.borderWidth = 2.f;
    self.deleteAllButton.clipsToBounds = YES;
    [self.deleteAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.deleteAllButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateHighlighted];
    [self.deleteAllButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [self.deleteAllButton setTitle:@"清空" forState:UIControlStateNormal];
    [self.deleteAllButton addTarget:self action:@selector(deleteAllAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.emptyLabel = [[UILabel alloc]init];
    self.emptyLabel.text = @"未作答";
    self.emptyLabel.font = [UIFont boldSystemFontOfSize:27];
    self.emptyLabel.textColor = [UIColor colorWithHexString:@"69ad0a"];
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[QAConnectSelectedCell class] forCellReuseIdentifier:@"QAConnectSelectedCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.layer.cornerRadius = 6.f;
    self.tableView.clipsToBounds = YES;
}

- (void)setupLayout {
    [self addSubview:self.graycircleView];
    [self addSubview:self.circleImageView];
    [self addSubview:self.bgView];
    [self addSubview:self.foldButton];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.deleteAllButton];
    [self addSubview:self.emptyLabel];
    [self addSubview:self.tableView];

    [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(85, 41));
    }];
    [self.graycircleView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.circleImageView.mas_bottom);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(85, 46));
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.circleImageView.mas_bottom);
        make.bottom.mas_equalTo(10);
    }];
    [self.foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(5+18);
        make.right.mas_equalTo(-18);
    }];
    [self.deleteAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(50, 36));
    }];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset(35.f);
        make.left.mas_equalTo(15.f);
        make.right.bottom.mas_equalTo(-15.f);
    }];
}

- (void)foldAction {
    BLOCK_EXEC(self.foldBlock);
}

- (void)setIsFold:(BOOL)isFold {
    _isFold = isFold;
    if (isFold) {
        self.graycircleView.hidden = NO;
        [self.foldButton setBackgroundImage:[UIImage imageNamed:@"连线题篮子正常态"] forState:UIControlStateNormal];
        [self.foldButton setBackgroundImage:[UIImage imageNamed:@"连线题篮子正常态"] forState:UIControlStateHighlighted];
    }else {
        self.graycircleView.hidden = YES;
        [self.foldButton setBackgroundImage:[UIImage imageNamed:@"页面弹窗的收起按钮正常态"] forState:UIControlStateNormal];
        [self.foldButton setBackgroundImage:[UIImage imageNamed:@"页面弹窗的收起按钮点击态"] forState:UIControlStateHighlighted];
    }
}

- (void)deleteAllAction:(UIButton *)sender {
    if (self.optionInfoArray.count == 0) {
        return;
    }
    BLOCK_EXEC(self.deleteAllBlock,self.optionInfoArray);
}

#pragma mark - UITableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.optionInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    QAConnectSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAConnectSelectedCell"];
    QAConnectSelectedCell *cell = [[QAConnectSelectedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    QAConnectTwinOptionInfo *info = self.optionInfoArray[indexPath.row];
    [cell updateWithTwinOption:info];
    WEAK_SELF
    [cell setCellHeightChangeBlock:^(CGFloat height) {
        STRONG_SELF
        CGFloat cellHeight = self.optionInfoArray[indexPath.row].height;
        CGFloat newCellHeight = ceilf(height);
        if (cellHeight < newCellHeight) {
            self.optionInfoArray[indexPath.row].height = newCellHeight;
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }];
    [cell setDeleteOptionActionBlock:^(QAConnectTwinOptionInfo *twinOption) {
        STRONG_SELF
        twinOption.leftOptionInfo.selected = NO;
        twinOption.rightOptionInfo.selected = NO;
        BLOCK_EXEC(self.deleteBlock,twinOption);
        
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QAConnectTwinOptionInfo *info = self.optionInfoArray[indexPath.row];
    return info.height;
}

- (void)reloadData {
    self.emptyLabel.hidden = self.optionInfoArray.count!=0;
    [self.tableView reloadData];
}

- (void)setFoldActionBlock:(FoldActionBlock)block {
    self.foldBlock = block;
}

- (void)setDeleteActionBlock:(DeleteActionBlock)block {
    self.deleteBlock = block;
}

-(void)setDeleteAllActionBlock:(DeleteAllActionBlock)block {
    self.deleteAllBlock = block;
}
@end
