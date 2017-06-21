//
//  QAReadStemCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAReadStemCell.h"
#import "QACoreTextViewHandler.h"

@interface QAReadStemCell()
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@end

@implementation QAReadStemCell

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
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    [self.contentView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-20);
        make.right.mas_equalTo(-15);
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[QAReadStemCell maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat bottomMargin = self.contentView.height-CGRectGetMaxY(self.htmlView.frame);
        CGFloat totalHeight = self.htmlView.y+height+bottomMargin;
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
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

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    return height+50;
}

+ (CGFloat)heightForString:(NSString *)string isSubQuestion:(BOOL)isSub{
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

#pragma QAComplexHeaderCellDelegate
- (CGFloat)heightForQuestion:(QAQuestion *)question {
    return [QAReadStemCell heightForString:question.stem isSubQuestion:NO]-20;
}

- (void)setCellHeightDelegate:(id<YXHtmlCellHeightDelegate>)cellHeightDelegate {
    self.delegate = cellHeightDelegate;
}

- (id<YXHtmlCellHeightDelegate>)cellHeightDelegate {
    return self.delegate;
}

@end
