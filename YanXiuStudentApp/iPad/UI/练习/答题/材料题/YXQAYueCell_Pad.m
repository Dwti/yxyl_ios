//
//  YXQAYueCell_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAYueCell_Pad.h"

@interface YXQAYueCell_Pad()
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@end

@implementation YXQAYueCell_Pad


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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    [self.contentView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[YXQAYueCell_Pad maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        [self.delegate tableViewCell:self updateWithHeight:ceilf(height)];
    };
}

#pragma mark - 
- (void)setItem:(QAQuestion *)item{
    if (self.item == item) {
        return;
    }
    _item = item;
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringForString:item.stem];
}

+ (CGFloat)maxContentWidth{
    return [UIScreen mainScreen].bounds.size.width - 360 - 11 - 39 - 40 - 30 - 4;
}

+ (CGFloat)heightForString:(NSString *)string{
    CGFloat maxWidth = [self maxContentWidth];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string constraintedToWidth:maxWidth];
    CGFloat height = stringHeight;
    return ceilf(height);
}

@end
