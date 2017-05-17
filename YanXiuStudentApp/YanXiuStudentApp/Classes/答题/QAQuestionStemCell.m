//
//  QAQuestionStemCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/23.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAQuestionStemCell.h"
#import "QACoreTextViewHandler.h"

@interface QAQuestionStemCell()
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@end

@implementation QAQuestionStemCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    [self.contentView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-25);
        make.right.mas_equalTo(-15);
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[QAQuestionStemCell maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [QAQuestionStemCell totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)updateWithString:(NSString *)string isSubQuestion:(BOOL)isSub {
    NSDictionary *dic = nil;
    if (isSub) {
        dic = [YXQACoreTextHelper defaultOptionsForLevel2];
    }else{
        dic = [YXQACoreTextHelper defaultOptionsForLevel1];
    }
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringWithString:string options:dic];
}

+ (CGFloat)maxContentWidth {
    return SCREEN_WIDTH-30;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    return height+50;
}

+ (CGFloat)heightForString:(NSString *)string isSubQuestion:(BOOL)isSub{
    CGFloat maxWidth = [self maxContentWidth];
    NSDictionary *dic = nil;
    if (isSub) {
        dic = [YXQACoreTextHelper defaultOptionsForLevel2];
    }else{
        dic = [YXQACoreTextHelper defaultOptionsForLevel1];
    }
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string options:dic width:maxWidth];
    CGFloat height = [self totalHeightWithContentHeight:stringHeight];
    return height;
}

@end
