//
//  QAConnectQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAConnectQuestionView.h"
#import "YXQAConnectTitleCell.h"
#import "YXConnectContentCell.h"
#import "QAConnectTitleView.h"
#import "QAConnectContentCell.h"
#import "QAConnectContentView.h"

@interface QAConnectQuestionView ()
@property (nonatomic, strong) NSMutableArray *contentGroupArray;
@property (nonatomic, strong) QAConnectTitleView *connectTitleView;
@property (nonatomic, strong) QAConnectContentView *contentView;
@end

@implementation QAConnectQuestionView

- (void)setupUI {
    [super setupUI];
    self.tableView.hidden = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    self.connectTitleView = [[QAConnectTitleView alloc]init];
    [self.connectTitleView updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView] ;
    [self addSubview:self.connectTitleView];
    CGFloat height = [QAConnectTitleView heightForString:self.data.stem isSubQuestion:self.isSubQuestionView];
    [self.connectTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    
    self.contentView = [[QAConnectContentView alloc]init];
    self.contentView.item = self.data;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.connectTitleView.mas_bottom);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.bottom.mas_equalTo(-80);
    }];
}


@end
