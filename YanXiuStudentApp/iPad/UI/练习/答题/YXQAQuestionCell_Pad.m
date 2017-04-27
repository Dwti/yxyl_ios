//
//  YXQAQuestionCell_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAQuestionCell_Pad.h"
#import "YXQAUtils.h"

@interface YXQAQuestionCell_Pad()
@property(nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@property(nonatomic, strong) YXSmartDashLineView *lineView;
@property(nonatomic, strong) UIImageView *stemBgView;
@end

@implementation YXQAQuestionCell_Pad


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
    UIImageView *q = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Q"]];
    [self.contentView addSubview:q];
    [q mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(39);
        make.top.mas_equalTo(27);
        make.size.mas_equalTo(CGSizeMake(28, 30));
    }];
    
    YXSmartDashLineView *line = [[YXSmartDashLineView alloc]init];
    line.dashWidth = 5;
    line.gapWidth = 2;
    line.lineColor = [UIColor colorWithHexString:@"ccc4a3"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    self.lineView = line;
    
    UIImageView *stemBgView = [[UIImageView alloc]initWithImage:[YXQAUtils stemBgImage]];
    [self.contentView addSubview:stemBgView];
    [stemBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(73);
        make.top.mas_equalTo(20).priorityHigh();
        make.right.mas_equalTo(-40);
        make.bottom.mas_equalTo(-20-1-20).priorityHigh();
    }];
    self.stemBgView = stemBgView;
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    [stemBgView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.left.mas_equalTo(24);
        make.bottom.mas_equalTo(-17);
        make.right.mas_equalTo(-17);
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[YXQAQuestionCell_Pad maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [YXQAQuestionCell_Pad totalHeightWithContentHeight:height dashHidden:self.dashLineHidden];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
}

#pragma mark - Setters
- (void)setDashLineHidden:(BOOL)dashLineHidden{
    _dashLineHidden = dashLineHidden;
    if (dashLineHidden) {
        [self.lineView removeFromSuperview];
        [self.stemBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(73);
            make.top.mas_equalTo(20).priorityHigh();
            make.right.mas_equalTo(-40);
            make.bottom.mas_equalTo(-20).priorityHigh();
        }];
    }
}

- (void)setItem:(QAQuestion *)item{
    if (self.item == item) {
        return;
    }
    _item = item;
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringForString:item.stem];
}

#pragma mark -
+ (CGFloat)maxContentWidth{
    return [UIScreen mainScreen].bounds.size.width - 360 - 11 - 80 - 40 - 30 - 4;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height dashHidden:(BOOL)dashHidden{
    CGFloat h = 20 + 2 + 15 + height + 15 + 2 + 20 + 1 + 20;
    if (dashHidden) {
        h -= 21;
    }
    return ceilf(h);
}

+ (CGFloat)heightForString:(NSString *)string dashHidden:(BOOL)dashHidden{
    CGFloat maxWidth = [YXQAQuestionCell_Pad maxContentWidth];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string constraintedToWidth:maxWidth];
    CGFloat height = [YXQAQuestionCell_Pad totalHeightWithContentHeight:stringHeight dashHidden:dashHidden];
    return height;
}

@end
