//
//  YXQAAnalysisAnalysisCell_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAAnalysisAnalysisCell_Pad.h"

@interface YXQAAnalysisAnalysisCell_Pad()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;

@end

@implementation YXQAAnalysisAnalysisCell_Pad


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
    
    UIView *containerView = [[UIView alloc]init];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.clipsToBounds = YES;
    containerView.layer.cornerRadius = 10;
    containerView.layer.borderWidth = 2;
    containerView.layer.borderColor = [UIColor colorWithHexString:@"ccc4a3"].CGColor;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(39).priorityHigh();
        make.top.mas_equalTo(self.typeImageView.mas_bottom).mas_offset(15).priorityHigh();
        make.bottom.mas_equalTo(-10).priorityHigh();
        make.right.mas_equalTo(-40);
    }];
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    [containerView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.left.mas_equalTo(17);
        make.bottom.mas_equalTo(-17);
        make.right.mas_equalTo(-17);
    }];
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[YXQAAnalysisAnalysisCell_Pad maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [YXQAAnalysisAnalysisCell_Pad totalHeightWithContentHeight:height];
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
    return [UIScreen mainScreen].bounds.size.width - 360 - 11 - 39 - 40 - 17 - 17;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    return ceilf(30 + 18 + 15 + 17 + height + 17 + 10);
}

+ (CGFloat)heightForString:(NSString *)string{
    CGFloat maxWidth = [self maxContentWidth];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string constraintedToWidth:maxWidth];
    CGFloat height = [self totalHeightWithContentHeight:stringHeight];
    return height;
}

@end
