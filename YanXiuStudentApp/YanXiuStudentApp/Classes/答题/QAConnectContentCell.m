//
//  QAConnectContentCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAConnectContentCell.h"

@interface QAConnectContentCell()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;

@end


@implementation QAConnectContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.containerView.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
        self.containerView.clipsToBounds = NO;
        [self setShadow];
    }else {
        self.containerView.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        self.containerView.clipsToBounds = YES;
    }
    // Configure the view for the selected state
}

- (void)setShadow {
    self.containerView.layer.shadowColor = [UIColor colorWithHexString:@"89e00d"].CGColor;;
    self.containerView.layer.shadowOffset = CGSizeMake(0,0);
    self.containerView.layer.shadowOpacity = 0.24;
    self.containerView.layer.shadowRadius = 8;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.containerView = [[UIImageView alloc]init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 6.0f;
    self.containerView.layer.borderWidth = 2.0f;
    self.containerView.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    [self.contentView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 20, 10, 20));
    }];
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    self.htmlView.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(13, 15, 13, 15));
    }];
}

- (void)setMaxContentWidth:(CGFloat)maxContentWidth{
    _maxContentWidth = maxContentWidth;
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:self.maxContentWidth];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [QAConnectContentCell totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:(UITableViewCell *)self updateWithHeight:totalHeight];
    };
}

- (void)setContent:(NSString *)content{
    if ([_content isEqualToString:content]) {
        return;
    }
    _content = content;
    NSDictionary *dic = [YXQACoreTextHelper defaultOptionsForConnectOptions];
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringWithString:content options:dic];
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    CGFloat h = 10 + 13 + height + 13 + 10;
    return ceilf(h);
}

+ (CGFloat)heightForString:(NSString *)string width:(CGFloat)width {
    NSDictionary *dic = [YXQACoreTextHelper defaultOptionsForConnectOptions];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string options:dic width:width];
    CGFloat height = [self totalHeightWithContentHeight:stringHeight];
    return height;
}
@end
