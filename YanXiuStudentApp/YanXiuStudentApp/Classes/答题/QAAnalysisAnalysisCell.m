//
//  QAAnalysisAnalysisCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisAnalysisCell.h"

@interface QAAnalysisAnalysisCell()
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@end

@implementation QAAnalysisAnalysisCell

- (void)setupUI{
    [super setupUI];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    self.htmlView.backgroundColor = [UIColor clearColor];
    
    [self.containerView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(11).priorityHigh();
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-9).priorityHigh();
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[QAAnalysisAnalysisCell maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [QAAnalysisAnalysisCell totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
}

+ (CGFloat)maxContentWidth{
    return [UIScreen mainScreen].bounds.size.width - 15 - 15;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    CGFloat fixHeight = 13 + 14 + 13 + 9;
    return ceilf(height + fixHeight);
}

+ (CGFloat)heightForString:(NSString *)string{
    CGFloat maxWidth = [self maxContentWidth];
    NSDictionary *dic = nil;
    dic = [YXQACoreTextHelper defaultOptionsForAnalysisAnalysisItems];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string options:dic width:maxWidth];
    CGFloat height = [QAAnalysisAnalysisCell totalHeightWithContentHeight:stringHeight];
    return height;
}

- (void)setHtmlString:(NSString *)htmlString{
    _htmlString = htmlString;
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringForString:htmlString];
}

@end
