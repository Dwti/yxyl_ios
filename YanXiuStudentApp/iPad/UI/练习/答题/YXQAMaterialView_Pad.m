//
//  YXQAMaterialView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAMaterialView_Pad.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "YXQAWenHeaderView_Pad.h"
#import "YXQATitleCell_Pad.h"
#import "YXQAYueCell_Pad.h"
#import "YXQASingleChooseView_Pad.h"
#import "YXQAMultiChooseView_Pad.h"
#import "YXQAYesNoView_Pad.h"
#import "YXQAFillBlankView_Pad.h"

@interface YXQAMaterialView_Pad()<YXSlideViewDataSource, YXSlideViewDelegate, DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate, YXAutoGoNextDelegate,UITableViewDelegate,UITableViewDataSource,YXHtmlCellHeightDelegate>
@property (nonatomic, strong) UIView *upContainerView;
@property (nonatomic, strong) UIView *downContainerView;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, assign) CGFloat yueCellHeight;
@property (nonatomic, strong) YXQAWenHeaderView_Pad *wenHeaderView;

@end

@implementation YXQAMaterialView_Pad{
    BOOL _bLayoutDone;
    BOOL _bUpFold;
    DTAttributedTextContentView *_htmlView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_bLayoutDone) {
        [self _setupUI];
    }
    _bLayoutDone = YES;
    
    [self layoutIfNeeded];
}

- (void)cancelLoading {
    [self.slideView.currentView cancelLoading]; // 存储最后一页的数据
}

- (void)_setupUI {
    self.backgroundColor = [UIColor clearColor];
    _bUpFold = YES;
    
    // “阅” 部分
    
    self.upContainerView = [[UIView alloc] init];
    [self addSubview:self.upContainerView];
    YXQATitleCell_Pad *titleCell = [[YXQATitleCell_Pad alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [self.upContainerView addSubview:titleCell];
    [titleCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
    }];
    titleCell.item = self.data;
    titleCell.title = self.title;
    
    [self setupMaterialView];
    // “问” 部分
    
    self.downContainerView = [[UIView alloc] init];
    [self addSubview:self.downContainerView];
    self.wenHeaderView = [[YXQAWenHeaderView_Pad alloc]init];
    [self.downContainerView addSubview:self.wenHeaderView];
    [self.wenHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(34);
    }];
    QAQuestion *first = self.data.childQuestions.firstObject;
    [self.wenHeaderView updateWithIndex:0 total:self.data.childQuestions.count type:[first typeString]];
    
    [self setupQAView];
    
    [self.upContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(180);
    }];
    [self.downContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.upContainerView.mas_bottom);
    }];
}

// 没有containerView的话，_htmlView不会调用回调函数
static UIView *_containerView;
- (void)setupMaterialView {
    UIView *containerView = [[UIView alloc]init];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.clipsToBounds = YES;
    containerView.layer.cornerRadius = 10;
    containerView.layer.borderWidth = 2;
    containerView.layer.borderColor = [UIColor colorWithHexString:@"ccc4a3"].CGColor;
    [self.upContainerView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+35).priorityHigh();
        make.bottom.mas_equalTo(-25).priorityHigh();
        make.left.mas_equalTo(39);
        make.right.mas_equalTo(-40);
    }];
    self.yueCellHeight = [YXQAYueCell_Pad heightForString:self.data.stem];
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.upContainerView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        make.top.mas_equalTo(containerView.mas_top).mas_offset(15);
        make.bottom.mas_equalTo(containerView.mas_bottom).mas_offset(-15);
    }];
    [self.tableView registerClass:[YXQAYueCell_Pad class] forCellReuseIdentifier:@"YXQAYueCell_Pad"];
    
    UIButton *foldButton = [[UIButton alloc]init];
    [foldButton setBackgroundImage:[UIImage imageNamed:@"阅读展开按钮-背景"] forState:UIControlStateNormal];
    [foldButton setBackgroundImage:[UIImage imageNamed:@"阅读展开按钮-背景"] forState:UIControlStateHighlighted];
    [foldButton setImage:[UIImage imageNamed:@"阅读展开icon"] forState:UIControlStateNormal];
    foldButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [foldButton addTarget:self action:@selector(foldAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.upContainerView addSubview:foldButton];
    [foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView.mas_right);
        make.top.mas_equalTo(containerView.mas_top).mas_offset(17);
        make.size.mas_equalTo(CGSizeMake(37, 34));
    }];
}

- (void)setupQAView {
    self.slideView = [[YXSlideView alloc] init];
    self.slideView.datasource = self;
    self.slideView.delegate = self;
    self.slideView.startIndex = self.nextLevelStartIndex;
    [self.downContainerView addSubview:self.slideView];
    
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(34, 0, 0, 0));
    }];
}

- (void)foldAction:(UIButton *)sender {
    _bUpFold = !_bUpFold;
    if (_bUpFold) {
        sender.imageView.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self.upContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.top.left.right.mas_equalTo(0);
                                 make.height.mas_equalTo(180);
                             }];
                             [self.downContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.left.right.mas_equalTo(0);
                                 make.top.mas_equalTo(self.upContainerView.mas_bottom);
                             }];
                             [self layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             
                         }];
    } else {
        sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        [UIView animateWithDuration:0.3
                         animations:^{
                             // 由于下部不够现实 slide view, 所有会报 constraints conflict，暂时系统自己修正约束
                             [self.upContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.top.left.right.mas_equalTo(0);
                                 make.bottom.mas_equalTo(-47);
                             }];
                             [self.downContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.left.right.mas_equalTo(0);
                                 make.top.mas_equalTo(self.upContainerView.mas_bottom);
                             }];
                             [self layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

#pragma mark - table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.yueCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXQAYueCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAYueCell_Pad"];
    cell.delegate = self;
    cell.item = self.data;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - height delegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height {
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    if (!ip) {
        return;
    }
    
    CGFloat h = self.yueCellHeight;
    CGFloat nh = ceilf(height);
    if (h != nh) {
        self.yueCellHeight = nh;
        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView layoutIfNeeded];
    }
    
}

#pragma mark - slide tab datasource delegate

- (NSInteger)numberOfItemsInSlideView:(YXSlideView *)sender {
    return [self.data.childQuestions count];
}

- (YXSlideViewItemViewBase *)slideView:(YXSlideView *)sender viewForIndex:(NSInteger)index {
    if (self.data.childQuestions.count <= index) {
        return nil;
    }
    QAQuestion *data = [self.data.childQuestions objectAtIndex:index];
    if (data.templateType == YXQATemplateSingleChoose) {
        YXQASingleChooseView_Pad *v = [[YXQASingleChooseView_Pad alloc] init];
        v.data = data;
        v.bShowTitleState = NO;
        v.delegate = self;
        return v;
    }
    if (data.templateType == YXQATemplateMultiChoose) {
        YXQAMultiChooseView_Pad *v = [[YXQAMultiChooseView_Pad alloc] init];
        v.data = data;
        v.bShowTitleState = NO;
        return v;
    }
    if (data.templateType == YXQATemplateYesNo) {
        YXQAYesNoView_Pad *v = [[YXQAYesNoView_Pad alloc] init];
        v.data = data;
        v.bShowTitleState = NO;
        v.delegate = self;
        return v;
    }
    if (data.templateType == YXQATemplateFill) {
        YXQAFillBlankView_Pad *v = [[YXQAFillBlankView_Pad alloc] init];
        v.data = data;
        v.bShowTitleState = NO;
        return v;
    }
//    if (data.templateType == YXQAItemMaterial) {
//        YXQAMaterialView_Pad *v = [[YXQAMaterialView_Pad alloc]init];
//        v.data = (YXQAComplexItem *)data;
//        return v;
//    }
    
    return nil;
}

- (void)slideView:(YXSlideView *)aView slideFromIndex:(NSUInteger)from ToIndex:(NSUInteger)to {
    QAQuestion *item = self.data.childQuestions[to];
    [self.wenHeaderView updateWithIndex:to total:self.data.childQuestions.count type:[item typeString]];
}

- (void)autoGoNextGoGoGo {
    if (self.slideView.selectedIndex == ([self.data.childQuestions count] - 1)) {
        [self.slideView.currentView cancelLoading]; // 存储最后一页的数据
        [self.delegate autoGoNextGoGoGo];
        return;
    }
    
    [self.slideView goToIndex:self.slideView.selectedIndex+1 animated:YES];
}

@end
