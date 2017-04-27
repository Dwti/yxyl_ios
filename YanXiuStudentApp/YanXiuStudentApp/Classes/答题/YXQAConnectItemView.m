//
//  YXQAConnectItemView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAConnectItemView.h"

@interface YXQAConnectItemView()
@property (nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@end

@implementation YXQAConnectItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.bgImageView = [[UIImageView alloc]init];
    self.bgImageView.image = [UIImage yx_resizableImageNamed:@"通用背景"];
    self.bgImageView.clipsToBounds = YES;
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    self.htmlView.backgroundColor = [UIColor clearColor];
    [self.bgImageView addSubview:self.htmlView];
}

- (void)setMaxContentWidth:(CGFloat)maxContentWidth{
    _maxContentWidth = maxContentWidth;
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:self.maxContentWidth];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        [self.htmlView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_equalTo(self.maxContentWidth);
            make.height.mas_equalTo(height);
        }];
        
        CGFloat totalHeight = [YXQAConnectItemView totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:(UITableViewCell *)self updateWithHeight:totalHeight];
    };
    self.coreTextHandler.relayoutBlock = ^{
        STRONG_SELF
        [self.htmlView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_equalTo(self.maxContentWidth);
            make.height.mas_equalTo(self.htmlView.layoutFrame.frame.size.height);
        }];
        
    };
}

- (void)setState:(YXQAConnectState)state{
    _state = state;
    self.alpha = 1.0;
    self.bgImageView.image = [UIImage yx_resizableImageNamed:@"通用背景"];
    if (state == YXQAConnectStateDefault) {
        
    }else if (state == YXQAConnectStateSelected){
        self.alpha = 0.5;
    }else if (state == YXQAConnectStateConnected){
        self.bgImageView.image = [UIImage yx_resizableImageNamed:@"连线成功背景"];
    }
}

- (void)setContent:(NSString *)content{
    if ([_content isEqualToString:content]) {
        return;
    }
    _content = content;
    self.htmlView.attributedString = [YXQACoreTextHelper centerAttributedStringForString:content];
    
    CGFloat h = [YXQAConnectItemView heightForString:content width:self.maxContentWidth];
      [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(self.maxContentWidth, h-30));
    }];
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    CGFloat h = 15 + height + 15;
    return ceilf(h);
}

+ (CGFloat)heightForString:(NSString *)string width:(CGFloat)width{
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string constraintedToWidth:width];
    CGFloat height = [self totalHeightWithContentHeight:stringHeight];
    return height;
}

@end
