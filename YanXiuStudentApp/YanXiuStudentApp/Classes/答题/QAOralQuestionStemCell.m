//
//  QAOralQuestionStemCell.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAOralQuestionStemCell.h"
#import "QAIgnorePanGestureButton.h"

@interface QAOralQuestionStemCell ()<QACoreTextViewHandlerDelegate>
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation QAOralQuestionStemCell

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
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[QAOralQuestionStemCell maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = height==0.f? 0:[QAOralQuestionStemCell totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
    self.coreTextHandler.delegate = self;
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.bottomLineView = bottomLineView;
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

- (void)setBottomLineHidden:(BOOL)bottomLineHidden {
    _bottomLineHidden = bottomLineHidden;
    self.bottomLineView.hidden = bottomLineHidden;
}

+ (CGFloat)maxContentWidth {
    return SCREEN_WIDTH-30;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    return height+50;
}

+ (CGFloat)heightForString:(NSString *)string isSubQuestion:(BOOL)isSub{
    if (isEmpty(string)) {
        return 0.f;
    }
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

#pragma mark - QACoreTextViewHandlerDelegate
- (UIView *)viewForAttachment:(DTTextAttachment *)attachment {
    QAIgnorePanGestureButton *audioBtn = [QAIgnorePanGestureButton buttonWithType:UIButtonTypeCustom];
    audioBtn.frame = CGRectMake(0, 0, 34, 34);
    [audioBtn setImage:[UIImage imageNamed:@"语音播放默认图标"] forState:UIControlStateNormal];
    [audioBtn setImage:[UIImage imageNamed:@"语音播放默认图标-点击态"] forState:UIControlStateHighlighted];
    BLOCK_EXEC(self.audioBtnBlock, audioBtn, attachment.contentURL);
    return audioBtn;
}

@end
