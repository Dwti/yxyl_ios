//
//  QAListenStemCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAListenStemCell.h"
#import "QACoreTextViewHandler.h"
#import "LePlayer.h"
#import "UIView+YXScale.h"
#import "YXCommonLabel.h"
#import "ListenComplexPromptView.h"

static const CGFloat kHtmlViewTopMargin = 25.0f;
static const NSUInteger kPlayViewTopMargin = 12.0f;
static const NSUInteger kPlayViewHeight = 45.0f;
@interface QAListenStemCell()

@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;

@end

@implementation QAListenStemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    
    self.playView = [[QAListenPlayView alloc]init];

    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[QAListenStemCell maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat bottomMargin = self.height - CGRectGetMaxY(self.playView.frame);
        CGFloat totalHeight = height + kHtmlViewTopMargin + kPlayViewTopMargin + kPlayViewHeight + bottomMargin;
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
}

- (void)setupLayout {
    [self.contentView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kHtmlViewTopMargin);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    [self.contentView addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.htmlView.mas_bottom).offset(kPlayViewTopMargin);
        make.bottom.mas_equalTo(-12);
    }];
}

- (void)stop {
    [self.playView stop];
}

- (void)updateWithString:(NSString *)string isSubQuestion:(BOOL)isSub {
    NSDictionary *dic = nil;
    if (isSub) {
        dic = [YXQACoreTextHelper defaultOptionsForLevel2];
    }else{
        dic = [YXQACoreTextHelper defaultOptionsForLevel1];
    }
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringWithString:string options:dic];
}

+ (CGFloat)maxContentWidth {
    return SCREEN_WIDTH-30;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height {
    return height + 100;
}

+ (CGFloat)heightForString:(NSString *)string isSubQuestion:(BOOL)isSub {
    CGFloat maxWidth = [self maxContentWidth];
    NSDictionary *dic = nil;
    if (isSub) {
        dic = [YXQACoreTextHelper defaultOptionsForLevel2];
    }else{
        dic = [YXQACoreTextHelper defaultOptionsForLevel1];
    }
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string options:dic width:maxWidth];
    CGFloat height = [self totalHeightWithContentHeight:stringHeight];
    return height;
}

- (void)setItem:(QAQuestion *)item {
    if (_item == item) {
        return;
    }
    _item = item;
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringForString:item.stem];
    self.playView.item = item;
}

#pragma QAComplexHeaderCellDelegate
- (CGFloat)heightForQuestion:(QAQuestion *)question {
    return [QAListenStemCell heightForString:question.stem isSubQuestion:NO] - 31;
}

- (void)setCellHeightDelegate:(id<YXHtmlCellHeightDelegate>)cellHeightDelegate {
    self.delegate = cellHeightDelegate;
}

- (id<YXHtmlCellHeightDelegate>)cellHeightDelegate {
    return self.delegate;
}
@end
