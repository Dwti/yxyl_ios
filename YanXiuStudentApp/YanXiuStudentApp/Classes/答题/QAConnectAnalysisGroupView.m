//
//  QAConnectAnalysisGroupView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAConnectAnalysisGroupView.h"

static const CGFloat kMinHeight = 45.f;
static const CGFloat kMarginWidth = 35.f;

@interface QAConnectAnalysisGroupView()<YXHtmlCellHeightDelegate>

@property (nonatomic, assign) CGFloat currentHeight;
@end

@implementation QAConnectAnalysisGroupView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.leftView = [[QAConnectItemView alloc]init];
    self.leftView.delegate = self;
    self.leftView.maxContentWidth = [QAConnectAnalysisGroupView maxContentWidth];
    [self addSubview:self.leftView];
    
    self.rightView = [[QAConnectItemView alloc]init];
    self.rightView.delegate = self;
    self.rightView.maxContentWidth = [QAConnectAnalysisGroupView maxContentWidth];
    [self addSubview:self.rightView];
}

- (void)updateWithLeftContent:(NSString *)left rightContent:(NSString *)right{
    CGFloat width = [QAConnectAnalysisGroupView maxContentWidth];
    CGFloat l = [QAConnectItemView heightForString:left width:width];
    CGFloat r = [QAConnectItemView heightForString:right width:width];
    CGFloat ll = [QAConnectAnalysisGroupView itemHeightWithHeight:l];
    CGFloat rr = [QAConnectAnalysisGroupView itemHeightWithHeight:r];
    self.currentHeight = MAX(ll, rr);
    self.leftView.content = left;
    self.rightView.content = right;
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMarginWidth);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo([QAConnectAnalysisGroupView itemWidth]);
        make.height.mas_equalTo(ll);
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kMarginWidth);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo([QAConnectAnalysisGroupView itemWidth]);
        make.height.mas_equalTo(rr);
    }];
}

+ (CGFloat)itemHeightWithHeight:(CGFloat)height{
    return MAX(height, kMinHeight);
}

+ (CGFloat)itemWidth{
    return (SCREEN_WIDTH - 70 - 55)/2;
}

+ (CGFloat)maxContentWidth{
    return [self itemWidth] - 30;
}

+ (CGFloat)heightForLeftContent:(NSString *)left rightContent:(NSString *)right{
    CGFloat width = [self maxContentWidth];
    CGFloat l = [QAConnectItemView heightForString:left width:width];
    CGFloat r = [QAConnectItemView heightForString:right width:width];
    CGFloat ll = [QAConnectAnalysisGroupView itemHeightWithHeight:l];
    CGFloat rr = [QAConnectAnalysisGroupView itemHeightWithHeight:r];
    return MAX(ll, rr);
}

#pragma mark - YXHtmlCellHeightDelegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height{
    CGFloat h = [QAConnectAnalysisGroupView itemHeightWithHeight:height];

    if ((UIView *)cell == self.leftView) {
        [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kMarginWidth);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo([QAConnectAnalysisGroupView itemWidth]);
            make.height.mas_equalTo(h);
        }];
    }else if ((UIView *)cell == self.rightView){
        [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kMarginWidth);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo([QAConnectAnalysisGroupView itemWidth]);
            make.height.mas_equalTo(h);
        }];
    }
    if (h > self.currentHeight) {
        self.currentHeight = h;
        [self.delegate tableViewCell:(UITableViewCell *)self updateWithHeight:self.currentHeight];
    }
}

@end
