//
//  YXQAConnectGroupView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAConnectGroupView.h"

static const CGFloat kGapWidth = 42.f;
static const CGFloat kMinHeight = 65.f;

@interface YXQAConnectGroupView()<YXHtmlCellHeightDelegate>

@property (nonatomic, assign) CGFloat currentHeight;
@end

@implementation YXQAConnectGroupView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.leftView = [[YXQAConnectItemView alloc]init];
    self.leftView.maxContentWidth = [YXQAConnectGroupView maxContentWidth];
    self.leftView.delegate = self;
    [self addSubview:self.leftView];
    self.rightView = [[YXQAConnectItemView alloc]init];
    self.rightView.maxContentWidth = [YXQAConnectGroupView maxContentWidth];
    self.rightView.delegate = self;
    [self addSubview:self.rightView];
}

- (void)updateWithLeftContent:(NSString *)left rightContent:(NSString *)right{
    CGFloat width = [YXQAConnectGroupView maxContentWidth];
    CGFloat l = [YXQAConnectItemView heightForString:left width:width];
    CGFloat r = [YXQAConnectItemView heightForString:right width:width];
    CGFloat ll = [YXQAConnectGroupView itemHeightWithHeight:l];
    CGFloat rr = [YXQAConnectGroupView itemHeightWithHeight:r];
    self.currentHeight = MAX(ll, rr);
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake([YXQAConnectGroupView itemWidth], ll));
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake([YXQAConnectGroupView itemWidth], rr));
    }];
    self.leftView.content = left;
    self.rightView.content = right;
    self.rightView.hidden = !right.length;
}

+ (CGFloat)itemHeightWithHeight:(CGFloat)height{
    return MAX(height, kMinHeight);
}

+ (CGFloat)itemWidth{
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - 10 - 17 - 20 - 20 - kGapWidth)/2;
    return ceilf(itemWidth);
}

+ (CGFloat)maxContentWidth{
    return ceilf([self itemWidth]-40);
}

+ (CGFloat)heightForLeftContent:(NSString *)left rightContent:(NSString *)right{
    CGFloat width = [self maxContentWidth];
    CGFloat l = [YXQAConnectItemView heightForString:left width:width];
    CGFloat r = [YXQAConnectItemView heightForString:right width:width];
    CGFloat ll = [YXQAConnectGroupView itemHeightWithHeight:l];
    CGFloat rr = [YXQAConnectGroupView itemHeightWithHeight:r];
    return MAX(ll, rr);
}

#pragma mark - YXHtmlCellHeightDelegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height{
    CGFloat h = [YXQAConnectGroupView itemHeightWithHeight:height];
    if ((UIView *)cell == self.leftView) {
        [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake([YXQAConnectGroupView itemWidth], h));
        }];
    }else if ((UIView *)cell == self.rightView){
        [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake([YXQAConnectGroupView itemWidth], h));
        }];
    }
    if (h > self.currentHeight) {
        self.currentHeight = h;
        [self.delegate tableViewCell:(UITableViewCell *)self updateWithHeight:self.currentHeight];
    }
}

@end
