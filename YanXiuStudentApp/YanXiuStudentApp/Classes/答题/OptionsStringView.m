//
//  OptionsStringView.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "OptionsStringView.h"

@implementation OptionsStringView

- (UIImageView *)bgImageView{
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.backgroundColor = [UIColor colorWithRGBHex:0xffe580];
    bgImageView.layer.borderColor = [UIColor colorWithRGBHex:0x996600].CGColor;
    bgImageView.layer.cornerRadius = 5;
    bgImageView.layer.masksToBounds = YES;
    bgImageView.layer.borderWidth = 1.5;
    bgImageView.clipsToBounds = NO;
    return bgImageView;
}

- (UILabel *)titleLabelWithBgImageView:(UIView *)bgImageView obj:(id)obj{
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    titleLabel.x = 9;
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    if (!self.selected && !self.isAnalysis) {//答案跟解析都不能点
        WEAK_SELF
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            STRONG_SELF
            self.currentView = bgImageView;
            if (self.insertBlock) {
                self.insertBlock(obj);
            }
        }];
    }
    [titleLabel addGestureRecognizer:tap];
    return titleLabel;
}

- (void)setDatas:(NSMutableArray *)datas{
    [super setDatas:datas];
    CGFloat left = 40;//左边距
    CGFloat maxWidth = SCREEN_WIDTH - 10;//理论上是最大宽度，但实际没减左边距
    __block float y =  0;
    __block float x = left;
    __block UIView *tmp;
    if (self.selected) {//答案
        left = 20;
        x = left;
        maxWidth = SCREEN_WIDTH - 70;
        y =  20 + self.titleLabel.intrinsicContentSize.height;
    }
    
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *bgImageView = [self bgImageView];//背景图
        [self.bgScrollView addSubview:bgImageView];
        [self.views addObject:bgImageView];
        UIButton *closeButton = [self closeButtonWithObj:obj];
        [self.bgScrollView addSubview:closeButton];
        UILabel *titleLabel = [self titleLabelWithBgImageView:bgImageView obj:obj];
        titleLabel.attributedText = [YXQACoreTextHelper labelUsedAttributedStringForString:obj];
        [bgImageView addSubview:titleLabel];
        CGFloat space = 18;//label距离背景图
        [titleLabel sizeToFit];
        CGFloat labelMaxWidth;
        if (!self.selected) {
            labelMaxWidth = SCREEN_WIDTH - 70 - 10-space;
        }else{
            labelMaxWidth = SCREEN_WIDTH - 70 - 40 - 10-space;
        }
        [titleLabel setH:titleLabel.height+17];
        [titleLabel setW:MIN(titleLabel.width, labelMaxWidth)];
        bgImageView.y = y;
        bgImageView.size = CGSizeMake(titleLabel.size.width+space, titleLabel.size.height);
        if (x + space + bgImageView.width > maxWidth) {//换行
            y = tmp.maxY + 18;
            x = left;
        }
        bgImageView.x = x;
        bgImageView.y = y;
        closeButton.centerX = x + bgImageView.width;
        closeButton.centerY = y;
        titleLabel.centerX = bgImageView.width / 2;
        titleLabel.y = 0;
        [titleLabel setH:bgImageView.height];
        x+= bgImageView.width + space;
        tmp = bgImageView;
        if (idx == datas.count - 1) {
            self.estimatedHeight = bgImageView.maxY + 20 + 45;
        }
    }];
}

@end
