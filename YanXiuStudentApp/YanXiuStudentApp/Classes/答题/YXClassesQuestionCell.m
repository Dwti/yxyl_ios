//
//  YXClassesQuestionCell.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/8/17.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXClassesQuestionCell.h"

@interface YXClassesQuestionCell()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) DTAttributedTextContentView *questionLabel;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@end

@implementation YXClassesQuestionCell

#pragma mark-
- (DTAttributedTextContentView *)questionLabel
{
    if (!_questionLabel) {
        _questionLabel = [[DTAttributedTextContentView alloc]init];
        _questionLabel.backgroundColor = [UIColor clearColor];
    }
    return _questionLabel;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.clipsToBounds = YES;
        _containerView.layer.cornerRadius = 10;
        _containerView.layer.borderWidth = 2;
        _containerView.layer.borderColor = [UIColor colorWithHexString:@"ccc4a3"].CGColor;
        _containerView.backgroundColor = [UIColor whiteColor];
        [_containerView addSubview:self.questionLabel];
    }
    return _containerView;
}

#pragma mark- Set
- (void)setQuestion:(NSString *)question
{
    _question = question;
    self.questionLabel.attributedString = [YXQACoreTextHelper attributedStringForString:question];
}

#pragma mark-
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 20;
            make.left.offset = 30;
            make.right.offset = -30;
            make.bottom.offset = 0;
        }];
        [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 15;
            make.bottom.offset = -16;
            make.width.mas_equalTo(self.containerView).offset = -22;
            make.centerX.mas_equalTo(self.containerView);
        }];
        
        self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.questionLabel maxWidth:[YXClassesQuestionCell maxContentWidth]];
        WEAK_SELF
        self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
            STRONG_SELF
            CGFloat totalHeight = [YXClassesQuestionCell totalHeightWithContentHeight:height];
            [self.delegate tableViewCell:self updateWithHeight:totalHeight];
        };
    }
    return self;
}

- (CGFloat)cellHeight{
    CGFloat height = [YXQACoreTextHelper heightForString:self.question constraintedToWidth:self.width - 40];
    height += 31;
    return height;
}

+ (CGFloat)maxContentWidth{
    return [UIScreen mainScreen].bounds.size.width - 82;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    return ceilf(51 + height);
}

+ (CGFloat)heightForString:(NSString *)string{
    CGFloat maxWidth = [YXClassesQuestionCell maxContentWidth];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string constraintedToWidth:maxWidth];
    CGFloat height = [YXClassesQuestionCell totalHeightWithContentHeight:stringHeight];
    return height;
}

@end
