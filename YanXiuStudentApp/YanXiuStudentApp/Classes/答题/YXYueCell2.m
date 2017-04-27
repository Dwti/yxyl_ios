//
//  YXYueCell2.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/15.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXYueCell2.h"

@interface YXYueCell2()
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@end

@implementation YXYueCell2

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
//    UIView *containerView = [[UIView alloc]init];
//    containerView.backgroundColor = [UIColor whiteColor];
//    containerView.clipsToBounds = YES;
//    containerView.layer.cornerRadius = 10;
//    containerView.layer.borderWidth = 2;
//    containerView.layer.borderColor = [UIColor colorWithHexString:@"ccc4a3"].CGColor;
//    [self.contentView addSubview:containerView];
//    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.mas_equalTo(20).priorityHigh();
//        make.bottom.mas_equalTo(-25).priorityHigh();
//        make.right.mas_equalTo(-20);
//    }];
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    [self.contentView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[YXYueCell2 maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
    [self.delegate tableViewCell:self updateWithHeight:ceilf(height)];
    };
}

- (void)setItem:(QAQuestion *)item{
    if (self.item == item) {
        return;
    }
    _item = item;
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringForString:item.stem];
}

+ (CGFloat)maxContentWidth{
    return [UIScreen mainScreen].bounds.size.width - 10 - 17 - 20 - 20 - 30 - 4;
}

+ (CGFloat)heightForString:(NSString *)string{
    CGFloat maxWidth = [YXYueCell2 maxContentWidth];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string constraintedToWidth:maxWidth];
    CGFloat height = stringHeight;
    return ceilf(height);
}

@end
