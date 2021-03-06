//
//  QAAnalysisResultCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisResultCell.h"

static NSString *kQAAnswerResultState_Corret = @"回答正确";
static NSString *kQAAnswerResultState_Wrong = @"回答错误";

@interface QAAnalysisResultCell()
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@end


@implementation QAAnalysisResultCell

- (void)setupUI{
    [super setupUI];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.resultLabel = [[UILabel alloc]init];
    self.resultLabel.font = [UIFont boldSystemFontOfSize:27.0f];
    self.resultLabel.textColor = [UIColor whiteColor];
    
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    self.htmlView.backgroundColor = [UIColor clearColor];
    
    [self.containerView addSubview:self.resultLabel];
    [self.containerView addSubview:self.htmlView];
    
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(11.0f);
    }];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resultLabel.mas_bottom).mas_offset(9).priorityHigh();
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-13).priorityHigh();
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[QAAnalysisResultCell maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [QAAnalysisResultCell totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
}

+ (CGFloat)maxContentWidth{
    return [UIScreen mainScreen].bounds.size.width - 15 -15;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    CGFloat fixHeight = 15 + 14 + 15 + 27 + 13;
    if (height > 0) {
        fixHeight = fixHeight + 11 - 2;
    }
    return ceilf(height + fixHeight);
}

+ (CGFloat)heightForString:(NSString *)string{
    CGFloat maxWidth = [QAAnalysisResultCell maxContentWidth];
    NSDictionary *dic = nil;
    dic = [YXQACoreTextHelper defaultOptionsForAnalysisResultItem];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string options:dic width:maxWidth];
    CGFloat height = [QAAnalysisResultCell totalHeightWithContentHeight:stringHeight];
    return height;
}

- (void)setHtmlString:(NSString *)htmlString{
    _htmlString = htmlString;
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringForString:htmlString];
}

- (void)setMaxImageWidth:(CGFloat)maxImageWidth {
    _maxImageWidth = maxImageWidth;
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:maxImageWidth];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [QAAnalysisResultCell totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
}

- (void)updateUI {
    if (self.isCorrect) {
        self.resultLabel.text = kQAAnswerResultState_Corret;
        
    } else {
        self.resultLabel.text = kQAAnswerResultState_Wrong;
    }
}
@end
