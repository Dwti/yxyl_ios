//
//  YXLoginCell.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/21.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXLoginCell.h"
#import "UIColor+YXColor.h"
#import "YXDottedLineView.h"

NSString *const kYXLoginCellIdentifier = @"kYXLoginCellIdentifier";

@interface YXLoginCell ()

@property (nonatomic, strong) YXDottedLineView *lineView;

@end

@implementation YXLoginCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.interval = 2.f;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.showLine) {
        if (!self.lineView) {
            self.lineView = [[YXDottedLineView alloc] initWithFrame:CGRectMake(13, CGRectGetHeight(self.contentView.bounds) - 1, CGRectGetWidth(self.contentView.frame) - 26, 4) orientation:YXDottedLineOrientationHorizontal color:[UIColor whiteColor]];
            [self.lineView drawWithDotLength:7.f intervalLength:7.f];
            [self.contentView addSubview:self.lineView];
        }
        self.lineView.hidden = NO;
    } else {
        self.lineView.hidden = YES;
    }
}

- (void)setContainerView:(UIView *)containerView
{
    [_containerView removeFromSuperview];
    _containerView = containerView;
    _containerView.clipsToBounds = YES;
    [self.contentView addSubview:_containerView];
    [self remakeContainerViewConstraints];
}

- (void)setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    [self remakeContainerViewConstraints];
}

- (void)remakeContainerViewConstraints
{
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        if (self.showLine) {
            make.bottom.mas_equalTo(-self.interval);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
}

@end
