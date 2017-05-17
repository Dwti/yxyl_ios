//
//  QAChooseOptionCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/23.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAChooseOptionCell.h"

@interface QAChooseOptionCell()
@property (nonatomic, strong) UILabel *orderLabel;
@property (nonatomic, strong) UIImageView *selectionImageView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@end

@implementation QAChooseOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }else {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layer.shadowOffset = CGSizeMake(0, 2.5);
    self.layer.shadowRadius = 2.5;
    self.layer.shadowOpacity = 0.02;
    
    self.orderLabel = [[UILabel alloc]init];
    self.orderLabel.font = [UIFont boldSystemFontOfSize:20];
    self.orderLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.orderLabel];
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.selectionImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.selectionImageView];
    [self.selectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    self.htmlView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(self.orderLabel.mas_right).mas_offset(15);
        make.bottom.mas_equalTo(-20);
        make.right.mas_equalTo(self.selectionImageView.mas_left).mas_offset(-30);
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[QAChooseOptionCell maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [QAChooseOptionCell totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
    
    UIView *bottomLineView = [[UIView alloc]init];
    self.bottomLineView = bottomLineView;
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"e6e8e6"];
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.htmlView.mas_left);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)updateWithOption:(NSString *)option forIndex:(NSInteger)index {
    char c = 'A' + index;
    NSString *cString = [NSString stringWithFormat:@"%c.", c];
    self.orderLabel.text = cString;
    NSDictionary *dic = [YXQACoreTextHelper defaultOptionsForLevel3];
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringWithString:option options:dic];
}

- (void)setChoosed:(BOOL)choosed {
    _choosed = choosed;
    if (choosed) {
        self.selectionImageView.backgroundColor = [UIColor greenColor];
    }else {
        self.selectionImageView.backgroundColor = [UIColor redColor];
    }
}

- (void)setIsLast:(BOOL)isLast {
    _isLast = isLast;
    if (isLast) {
        self.bottomLineView.hidden = YES;
        self.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    }else {
        self.bottomLineView.hidden = NO;
        self.layer.shadowColor = [UIColor clearColor].CGColor;
    }
}

+ (CGFloat)maxContentWidth {
    return SCREEN_WIDTH-15-10-15-20-20-30;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    return height+40;
}

+ (CGFloat)heightForString:(NSString *)string{
    CGFloat maxWidth = [self maxContentWidth];
    NSDictionary *dic = [YXQACoreTextHelper defaultOptionsForLevel3];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string options:dic width:maxWidth];
    CGFloat height = [self totalHeightWithContentHeight:stringHeight];
    return height;
}

@end
