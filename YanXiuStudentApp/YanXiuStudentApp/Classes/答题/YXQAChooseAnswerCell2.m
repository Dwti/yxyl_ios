//
//  YXQAChooseAnswerCell2.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/9.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXQAChooseAnswerCell2.h"

@interface YXQAChooseAnswerCell2()
@property (nonatomic, strong) UIImageView *singleAView;
@property (nonatomic, strong) UIImageView *leftBgView;
@property (nonatomic, strong) UIImageView *centerBgView;
@property (nonatomic, strong) UIImageView *rightBgView;
@property (nonatomic, strong) UILabel *orderLabel;
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, strong) UIImageView *markView;
@end

@implementation YXQAChooseAnswerCell2


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
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.singleAView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"A"]];
    [self.contentView addSubview:self.singleAView];
    [self.singleAView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(26, 28));
    }];
    
    UIImage *left = [UIImage imageNamed:@"选项背景-1"];
    left = [left stretchableImageWithLeftCapWidth:15 topCapHeight:24];
    self.leftBgView = [[UIImageView alloc]initWithImage:left];
    [self.contentView addSubview:self.leftBgView];
    [self.leftBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-7);
        make.width.mas_equalTo(30);
    }];
    
    UIImage *center = [UIImage imageNamed:@"选项背景-2"];
    center = [center resizableImageWithCapInsets:UIEdgeInsetsMake(28, 10, 13, 10) resizingMode:UIImageResizingModeTile];
    self.centerBgView = [[UIImageView alloc]initWithImage:center];
    [self.contentView addSubview:self.centerBgView];
    [self.centerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftBgView.mas_right);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-7);
        make.width.mas_equalTo(22);
    }];
    
    UIImage *right = [UIImage imageNamed:@"选项背景-3"];
    right = [right stretchableImageWithLeftCapWidth:15 topCapHeight:24];
    self.rightBgView = [[UIImageView alloc]initWithImage:right];
    [self.contentView addSubview:self.rightBgView];
    [self.rightBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.centerBgView.mas_right);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-7);
        make.right.mas_equalTo(-20);
    }];
    
    self.orderLabel = [[UILabel alloc]init];
    self.orderLabel.textColor = [UIColor colorWithHexString:@"00cccc"];
    self.orderLabel.font = [UIFont fontWithName:YXFontArial size:24];
    self.orderLabel.textAlignment = NSTextAlignmentCenter;
    [self.leftBgView addSubview:self.orderLabel];
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(-1);
        make.width.mas_equalTo(40);
    }];
    
    self.markView = [[UIImageView alloc]init];
    self.markView.contentMode = UIViewContentModeLeft;
    [self.leftBgView addSubview:self.markView];
    [self.markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(30, 26));
        make.centerY.mas_equalTo(-1);
    }];
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    [self.contentView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60+40+16);
        make.top.mas_equalTo(16);
        make.right.mas_equalTo(-20-16);
        make.bottom.mas_equalTo(-10-16);
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[YXQAChooseAnswerCell2 maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [YXQAChooseAnswerCell2 totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
}

- (void)updateWithItem:(QAQuestion *)item forIndex:(NSInteger)index {
    self.item = item;
    char c = 'A' + index;
    NSString *cString = [NSString stringWithFormat:@"%c", c];
    self.orderLabel.text = cString;
    if (index != 0) {
        self.singleAView.hidden = YES;
    }else{
        self.singleAView.hidden = NO;
    }
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringForString:item.options[index]];
}

+ (CGFloat)maxContentWidth{
    return [UIScreen mainScreen].bounds.size.width-10-17-60-40-16-20-16;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    return ceilf(16 + height + 16 + 10);
}

+ (CGFloat)heightForString:(NSString *)string{
    CGFloat maxWidth = [YXQAChooseAnswerCell2 maxContentWidth];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string constraintedToWidth:maxWidth];
    CGFloat height = [YXQAChooseAnswerCell2 totalHeightWithContentHeight:stringHeight];
    return height;
}

- (void)setBChoosed:(BOOL)bChoosed {
    _bChoosed = bChoosed;
    if (bChoosed) {
        self.orderLabel.textColor = [UIColor whiteColor];
        UIImage *left = [UIImage imageNamed:@"选项背景按下-1"];
        left = [left stretchableImageWithLeftCapWidth:15 topCapHeight:24];
        self.leftBgView.image = left;
        UIImage *center = [UIImage imageNamed:@"选项背景按下-2"];
        center = [center resizableImageWithCapInsets:UIEdgeInsetsMake(28, 10, 13, 10) resizingMode:UIImageResizingModeTile];
        self.centerBgView.image = center;
    } else {
        self.orderLabel.textColor = [UIColor colorWithHexString:@"00cccc"];
        UIImage *left = [UIImage imageNamed:@"选项背景-1"];
        left = [left stretchableImageWithLeftCapWidth:15 topCapHeight:24];
        self.leftBgView.image = left;
        UIImage *center = [UIImage imageNamed:@"选项背景-2"];
        center = [center resizableImageWithCapInsets:UIEdgeInsetsMake(28, 10, 13, 10) resizingMode:UIImageResizingModeTile];
        self.centerBgView.image = center;
    }
}

- (void)setMarkType:(ChooseCellMarkType)markType{
    _markType = markType;
    if (self.markType == EMarkCorrect) {
        self.markView.image = [UIImage imageNamed:@"解析对勾"];
    }else if (self.markType == EMarkWrong){
        self.markView.image = [UIImage imageNamed:@"解析叉子"];
    }else{
        self.markView.image = nil;
    }
}


@end
