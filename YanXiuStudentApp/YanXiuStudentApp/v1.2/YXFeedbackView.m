//
//  YXFeedbackView.m
//  YanXiuStudentApp
//
//  Created by wd on 15/11/3.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXFeedbackView.h"

@interface YXFeedbackView ()

@property (nonatomic, assign) ContentShowType   showType;

@end

@implementation YXFeedbackView

- (instancetype)initWithFrame:(CGRect)frame showType:(ContentShowType)showType
{
    if (self = [super initWithFrame:frame]) {
        _showType = showType;
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _backgroundView = [[UIImageView alloc] initWithImage:nil];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    _backgroundView.userInteractionEnabled = YES;
    [self addSubview:_backgroundView];
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(160);
    }];
    
    _textView = [[SAMTextView alloc] init];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.placeholder = @"请描述您遇到的问题，或对我们提出宝贵建议......\n（4~500字）";
    if (_showType == ContentShowType_ReportError) {
        _textView.placeholder = @"在这里输入您遇到的问题";
    }
    _textView.font = [UIFont systemFontOfSize:15.f];
    _textView.layer.cornerRadius = 3.f;
    _textView.layer.borderColor = [YXLineColor colorWithAlphaComponent:0.5f].CGColor;
    _textView.layer.borderWidth = 1.f;
    _textView.clipsToBounds = YES;
    [_backgroundView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backgroundView);
    }];

#if 0
    _numbersLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _numbersLabel.backgroundColor = [UIColor clearColor];
    _numbersLabel.text = @"500字";
    _numbersLabel.textAlignment = NSTextAlignmentRight;
    _numbersLabel.font = [UIFont systemFontOfSize:13.f];
    [_backgroundView addSubview:_numbersLabel];
    [_numbersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backgroundView).with.offset(-5);
        make.bottom.equalTo(_backgroundView);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
#endif
}

@end
