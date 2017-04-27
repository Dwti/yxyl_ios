//
//  YXHotNumberLabel.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/4/5.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXHotNumberLabel.h"

@interface YXHotNumberLabel()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YXHotNumberLabel

#pragma mark- Get
- (UIImageView *)imageView
{
    if (!_imageView){
        _imageView = [UIImageView new];
        _imageView.image = [UIImage yx_resizableImageNamed:@"tab-dot背景"];
        _imageView.layer.shadowColor = [UIColor colorWithRGBHex:0xcc5252].CGColor;//shadowColor阴影颜色
        _imageView.layer.shadowOffset = CGSizeMake(0,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _imageView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        _imageView.layer.shadowRadius = 3;
    }
    return _imageView;
}

- (UILabel *)label
{
    if (!_label) {
        _label               = [UILabel new];
        _label.font          = [UIFont boldSystemFontOfSize:14];
        _label.textAlignment = NSTextAlignmentCenter;
//        _label.textColor               = [UIColor colorWithRGBHex:0xcc5252];
        _label.textColor     = [UIColor whiteColor];
        _label.preferredMaxLayoutWidth = 200;
    }
    return _label;
}

#pragma mark-
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.label;
}

#pragma mark- Masonry
- (void)addMasonry
{
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self);
//    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.label);
        make.width.mas_equalTo(self.label.mas_width).offset   = 10;
        make.height.mas_equalTo(self.label.mas_height).offset = 2;
    }];
}

#pragma mark-
- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        [self addMasonry];
        self.hidden = YES;
        @weakify(self)
        [[self.label rac_signalForSelector:@selector(setText:)] subscribeNext:^(id x) {
            @strongify(self)
            NSString *text = [x first];
            if (text.length == 1) {
                self.hidden = !text.integerValue;
            }else{
                self.hidden = !text.length;
            }
        } error:^(NSError *error) {
            
        }];
    }
    return self;
}

- (NSArray *)mas_makeConstraints:(void (^)(MASConstraintMaker *))block
{
    return [self.label mas_makeConstraints:block];
}

@end
