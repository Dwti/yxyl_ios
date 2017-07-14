//
//  QAConnectItemView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAConnectItemView.h"

@interface QAConnectItemView()
@property (nonatomic, strong) UIView *backGroundView;
@property(nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@end

@implementation QAConnectItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backGroundView = [[UIView alloc]init];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    self.backGroundView.layer.cornerRadius = 6.0f;
    [self addSubview:self.backGroundView];
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    self.htmlView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.htmlView];
}

- (void)setMaxContentWidth:(CGFloat)maxContentWidth {
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
        
        CGFloat totalHeight = [QAConnectItemView totalHeightWithContentHeight:height];
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

- (void)setContent:(NSString *)content {
    if ([_content isEqualToString:content]) {
        return;
    }
    _content = content;
    NSDictionary *dic = [YXQACoreTextHelper defaultOptionsForConnectOptions];
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringWithString:content options:dic];
    
    CGFloat h = [QAConnectItemView heightForString:content width:self.maxContentWidth];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(self.maxContentWidth, h-24));
    }];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        self.backGroundView.layer.borderWidth = 2.0f;
        self.backGroundView.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
        self.backGroundView.clipsToBounds = NO;
        self.backGroundView.layer.shadowColor = [UIColor colorWithHexString:@"89e00d"].CGColor;;
        self.backGroundView.layer.shadowOffset = CGSizeMake(0,0);
        self.backGroundView.layer.shadowOpacity = 0.24;
        self.backGroundView.layer.shadowRadius = 8;
    }else {
        self.backGroundView.layer.borderWidth = 2.0f;
        self.backGroundView.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        self.backGroundView.clipsToBounds = YES;
    }
}

-(void)setAnswerState:(YXQAAnswerState)answerState {
    _answerState = answerState;
    if (answerState == YXAnswerStateCorrect) {
        self.backGroundView.layer.borderWidth = 2.0f;
        self.backGroundView.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
        self.backGroundView.clipsToBounds = YES;
    }else {
        self.backGroundView.layer.borderWidth = 2.0f;
        self.backGroundView.layer.borderColor = [UIColor colorWithHexString:@"ff7a05"].CGColor;
        self.backGroundView.clipsToBounds = YES;
    }
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height {
    CGFloat h = 12 + height + 12;
    return ceilf(h);
}

+ (CGFloat)heightForString:(NSString *)string width:(CGFloat)width {
    NSDictionary *dic = [YXQACoreTextHelper defaultOptionsForConnectOptions];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string options:dic width:width];
    CGFloat height = [self totalHeightWithContentHeight:stringHeight];
    return height;
}
@end
