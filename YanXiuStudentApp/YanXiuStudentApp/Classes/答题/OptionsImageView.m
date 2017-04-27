//
//  OptionsImageView.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "OptionsImageView.h"
#import "UIButton+WebCache.h"

@interface OptionsImageView()

@property (nonatomic, assign) CGFloat length;

@end

@implementation OptionsImageView

- (CGFloat)length{
    if (self.selected) {
        return (SCREEN_WIDTH - 60 - 110) / 4;
    }else{
        return (SCREEN_WIDTH - 60 - 80) / 4;
    }
}

- (UIImageView *)bgImageView{
    UIImageView *bgImageView = [UIImageView new];//背景图
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = [UIImage imageNamed:@"主观题继续上传边框"];
    bgImageView.size = CGSizeMake(self.length, self.length);
    return bgImageView;
}

- (UIButton *)contentButtonWithBgImageView:(UIView *)bgImageView obj:(id)obj{
    UIButton *contentButton = [UIButton new];
    contentButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    contentButton.layer.cornerRadius = 8;
    contentButton.layer.masksToBounds = YES;
    [contentButton setImage:[UIImage imageNamed:@"04-250414.jpg"] forState:UIControlStateNormal];
    contentButton.frame = CGRectMake(4, 4, self.length - 8, self.length - 8);
    WEAK_SELF
    if (!self.selected && !self.isAnalysis) {//答案跟解析都不能点
        [[contentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG_SELF
            self.currentView = bgImageView;
            if (self.insertBlock) {
                self.insertBlock(obj);
            }
        }];
    }else{
        contentButton.userInteractionEnabled = NO;
    }
    return contentButton;
}

- (NSURL *)getUrlWithModel:(id)obj{
//    NSString *str = [obj substringFromIndex:10];
//    
//    NSArray *array = [str componentsSeparatedByString:@"\""];
//    str = array.firstObject;
    NSRange range = [obj rangeOfString:@"http://.+?\\.(jpg|png|jpeg)" options:NSRegularExpressionSearch];
    NSString *str = [obj substringWithRange:range];
    return [NSURL URLWithString:str];
}

- (void)setDatas:(NSMutableArray *)datas{
    [super setDatas:datas];
    CGFloat left = 40;//左边距
    CGFloat vSpace = 10;
    CGFloat hSpace = 20;
    __block float y =  0;
    __block float x = left;
    __block UIView *tmp;
    if (self.selected) {//答案
        left = 20;
        x = left;
        vSpace = 16;
        y =  20 + self.titleLabel.intrinsicContentSize.height;
    }
    
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *bgImageView = [self bgImageView];//背景图
        bgImageView.tag = idx;
        [self.bgScrollView addSubview:bgImageView];
        UIButton *contentButton = [self contentButtonWithBgImageView:bgImageView obj:obj];
        [contentButton sd_setImageWithURL:[self getUrlWithModel:obj] forState:UIControlStateNormal];
        [bgImageView addSubview:contentButton];
        UIButton *closeButton = [self closeButtonWithObj:obj];
        [self.bgScrollView addSubview:closeButton];
        if
            (idx % 4 == 0 && idx != 0) {//换行 一行只放4张图
            y += self.length + vSpace;
            x = left;
        }
        bgImageView.x = x;
        bgImageView.y = y;
        closeButton.centerX = x + bgImageView.width;
        closeButton.centerY = y;
        x+= self.length + hSpace;
        tmp = bgImageView;
        if (idx == datas.count - 1) {
            self.estimatedHeight = bgImageView.maxY + 20 + 45;
        }
    }];
}

@end
