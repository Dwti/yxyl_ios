//
//  QAQuestionNumberButton.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/21.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAQuestionNumberButton.h"
#import "UIButton+WaveHighlight.h"

static const CGFloat kCornerRadius = 25;
typedef NS_ENUM(NSInteger, QAQuestionNumberStyle) {
    QAQuestionNumberStyle_Default = 1,
    QAQuestionNumberStyle_Complex = 2,
} ;

@interface QAQuestionNumberButton ()
@property (nonatomic, assign) QAQuestionNumberStyle style;
@property (nonatomic, strong) UILabel *questionNumLabel;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, copy) ClickActionBlock buttonActionBlock;
@end

@implementation QAQuestionNumberButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
//    self.textColor = @"ffffff";
//    self.highlightedTextColor = @"ffffff";
    self.layer.cornerRadius = kCornerRadius;
    self.clipsToBounds = YES;
    self.isWaveHighlight = YES;
    
    self.questionNumLabel = [[UILabel alloc]init];
    self.questionNumLabel.font = [UIFont fontWithName:YXFontMetro_Regular size:21];
    
    self.indexLabel = [[UILabel alloc]init];
    self.indexLabel.font = [UIFont fontWithName:YXFontMetro_Regular size:21];
    
    self.lineView = [[UIView alloc]init];
    
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.font = [UIFont fontWithName:YXFontMetro_Regular size:16];
}

- (void)layoutQuestionNumLabel {
    [self addSubview:self.questionNumLabel];
    [self.questionNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (void)layoutComplexNumLabel {
    [self addSubview:self.indexLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.detailLabel];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 1));
    }];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(6);
        make.bottom.mas_equalTo(self.lineView.mas_top).offset(4);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(-2);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    if ([title containsString:@"-"]) {
        self.style = QAQuestionNumberStyle_Complex;
        NSArray *array = [title componentsSeparatedByString:@"-"];
        NSString *questionString = array.firstObject;
        NSString *detailString = array.lastObject;
        self.indexLabel.text = questionString;
        self.detailLabel.text = [NSString stringWithFormat:@"%@%@%@",@"(",detailString,@")"];
    }else {
        self.style = QAQuestionNumberStyle_Default;
        self.questionNumLabel.text = title;
    }
}

- (void)setStyle:(QAQuestionNumberStyle)style {
    _style = style;
    if (style == QAQuestionNumberStyle_Default) {
        [self.indexLabel removeFromSuperview];
        [self.lineView removeFromSuperview];
        [self.detailLabel removeFromSuperview];
        [self layoutQuestionNumLabel];
        
    }else if (style == QAQuestionNumberStyle_Complex) {
        [self.questionNumLabel removeFromSuperview];
        [self layoutComplexNumLabel];
    }
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    [self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@正常态",imageName]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@点击态",imageName]] forState:UIControlStateHighlighted];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self setSubviewsTextColor:textColor];
}

- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
    _highlightedTextColor = highlightedTextColor;
}

- (void)setSubviewsTextColor:(UIColor *)color {
    self.questionNumLabel.textColor = color;
    self.indexLabel.textColor = color;
    self.lineView.backgroundColor = color;
    self.detailLabel.textColor = color;
}

- (void)setClickActionBlock:(ClickActionBlock)block {
    self.buttonActionBlock = block;
}
#pragma mark - touch event
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint)) {
        [self setSubviewsTextColor:self.highlightedTextColor];
        return YES;
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    CGRect rect = self.frame;
    rect.size.width  = rect.size.width + 70;
    rect.size.height = rect.size.height + 70;

    if (CGRectContainsPoint(rect, touchPoint)) {
        [self setSubviewsTextColor:self.highlightedTextColor];
    }else {
        [self setSubviewsTextColor:self.textColor];
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self setSubviewsTextColor:self.textColor];
    BLOCK_EXEC(self.buttonActionBlock);
}

@end
