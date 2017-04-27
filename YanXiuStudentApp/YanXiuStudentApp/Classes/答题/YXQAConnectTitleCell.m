//
//  YXQAConnectTitleCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAConnectTitleCell.h"

@interface YXQAConnectTitleCell()
@property(nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;

@end

@implementation YXQAConnectTitleCell

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
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];

    UIView *containerView = [[UIView alloc]init];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.clipsToBounds = YES;
    containerView.layer.cornerRadius = 10;
    containerView.layer.borderWidth = 2;
    containerView.layer.borderColor = [UIColor colorWithHexString:@"ccc4a3"].CGColor;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-35);
    }];
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    [containerView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-17);
        make.right.mas_equalTo(-15);
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[YXQAConnectTitleCell maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [YXQAConnectTitleCell totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
}

- (void)setTitle:(NSString *)title{
    if ([_title isEqualToString:title]) {
        return;
    }
    _title = title;
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringForString:title];
}

+ (CGFloat)maxContentWidth{
    return [UIScreen mainScreen].bounds.size.width - 10 - 17 - 20 - 20 - 30;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    CGFloat h = 20 + 2 + 15 + height + 15 + 2 + 35;
    return ceilf(h);
}

+ (CGFloat)heightForString:(NSString *)string{
    CGFloat maxWidth = [self maxContentWidth];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string constraintedToWidth:maxWidth];
    CGFloat height = [self totalHeightWithContentHeight:stringHeight];
    return height;
}

@end
