//
//  YXLabelHtmlCell2.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/21.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXLabelHtmlCell2.h"
#import "YXQADashLineView.h"

@interface YXLabelHtmlCell2()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@end

@implementation YXLabelHtmlCell2


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier maxImageWidth:[YXLabelHtmlCell2 maxContentWidth]];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier maxImageWidth:(CGFloat)width {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.maxImageWidth = width;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    YXQADashLineView *dashView = [[YXQADashLineView alloc]init];
    [self.contentView addSubview:dashView];
    [dashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(1);
    }];
    
    self.typeImageView = [[UIImageView alloc]init];
    self.typeImageView.contentMode = UIViewContentModeLeft;
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(60, 18));
    }];
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    self.htmlView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeImageView.mas_bottom).mas_offset(15).priorityHigh();
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-10).priorityHigh();
        make.right.mas_equalTo(-20);
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:self.maxImageWidth];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [YXLabelHtmlCell2 totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
}

+ (CGFloat)maxContentWidth{
    return [UIScreen mainScreen].bounds.size.width - 10 - 17 - 20 - 20;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    return ceilf(30 + 18 + 15 + height + 10);
}

+ (CGFloat)heightForString:(NSString *)string{
    CGFloat maxWidth = [YXLabelHtmlCell2 maxContentWidth];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string constraintedToWidth:maxWidth];
    CGFloat height = [YXLabelHtmlCell2 totalHeightWithContentHeight:stringHeight];
    return height;
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

@end
