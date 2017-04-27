//
//  YXQAAnalysisLabelHtmlCell_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAAnalysisLabelHtmlCell_Pad.h"

@interface YXQAAnalysisLabelHtmlCell_Pad()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@end

@implementation YXQAAnalysisLabelHtmlCell_Pad

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    YXSmartDashLineView *line = [[YXSmartDashLineView alloc]init];
    line.dashWidth = 5;
    line.gapWidth = 2;
    line.lineColor = [UIColor colorWithHexString:@"ccc4a3"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(39);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(1);
    }];
    
    self.typeImageView = [[UIImageView alloc]init];
    self.typeImageView.contentMode = UIViewContentModeLeft;
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(39);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(60, 18));
    }];
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    self.htmlView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeImageView.mas_bottom).mas_offset(15).priorityHigh();
        make.left.mas_equalTo(39);
        make.bottom.mas_equalTo(-10).priorityHigh();
        make.right.mas_equalTo(-40);
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[YXQAAnalysisLabelHtmlCell_Pad maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [YXQAAnalysisLabelHtmlCell_Pad totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
}

#pragma mark - Setters
- (void)setItem:(YXQAAnalysisItem *)item{
    _item = item;
    self.typeImageView.image = [UIImage imageNamed:[item typeString]];
}

- (void)setHtmlString:(NSString *)htmlString{
    _htmlString = htmlString;
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringForString:htmlString];
}

#pragma mark - 
+ (CGFloat)maxContentWidth{
    return [UIScreen mainScreen].bounds.size.width - 360 - 11 - 39 - 40;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    return ceilf(30 + 18 + 15 + height + 10);
}

+ (CGFloat)heightForString:(NSString *)string{
    CGFloat maxWidth = [self maxContentWidth];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string constraintedToWidth:maxWidth];
    CGFloat height = [self totalHeightWithContentHeight:stringHeight];
    return height;
}

@end
