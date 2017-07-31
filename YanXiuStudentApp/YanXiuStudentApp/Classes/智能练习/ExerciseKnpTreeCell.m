//
//  ExerciseKnpTreeCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseKnpTreeCell.h"
#import "UIButton+ExpandHitArea.h"

typedef void(^ExpandBlock) (ExerciseKnpTreeCell *cell);
typedef void(^ClickBlock) (ExerciseKnpTreeCell *cell);

@interface ExerciseKnpTreeCell()
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIButton *expandButton;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UIView *thirdLineView;
@property (nonatomic, strong) UIView *fourthLineView;
@property (nonatomic, strong) UIButton *contentBgButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;

@property (nonatomic, copy) ExpandBlock expandBlock;
@property (nonatomic, copy) ClickBlock clickBlock;
@end

@implementation ExerciseKnpTreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - setupUI
- (void)setupUI {
    [super setupUI];
    
    self.shadowView = [[UIView alloc]init];
    self.shadowView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.shadowView.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;;
    self.shadowView.layer.shadowOffset = CGSizeMake(0,2.5);
    self.shadowView.layer.shadowOpacity = 0.02;
    self.shadowView.layer.shadowRadius = 2.5;
    [self.contentView addSubview:self.shadowView];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    self.expandButton = [[UIButton alloc]init];
    [self.expandButton setHitTestEdgeInsets:UIEdgeInsetsMake(50, 50, 50, 50)];
    [self.expandButton addTarget:self action:@selector(expandButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.expandButton];
    
    self.firstLineView = [[UIView alloc]init];
    self.firstLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:self.firstLineView];
    
    self.contentBgButton = [[UIButton alloc]init];
    [self.contentBgButton addTarget:self action:@selector(contentBgButtonTouchUpInsideAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentBgButton addTarget:self action:@selector(contentBgButtonTouchDownAction) forControlEvents:UIControlEventTouchDown];
    [self.contentBgButton addTarget:self action:@selector(contentBgButtonTouchDragOutsideAction) forControlEvents:UIControlEventTouchDragOutside];
    [self.contentBgButton addTarget:self action:@selector(contentBgButtonTouchDragInsideAction) forControlEvents:UIControlEventTouchDragInside];
    [self.contentBgButton addTarget:self action:@selector(contentBgButtonTouchCancelAction) forControlEvents:UIControlEventTouchCancel];
    
    [self.contentView addSubview:self.contentBgButton];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentBgButton addSubview:self.titleLabel];
    
    self.accessoryImageView = [[UIImageView alloc] init];
    self.accessoryImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.accessoryImageView.image = [UIImage imageNamed:@"章节列表进入按钮正常态"];
    self.accessoryImageView.highlightedImage = [UIImage imageNamed:@"章节列表进入按钮点击态"];
    [self.contentBgButton addSubview:self.accessoryImageView];
    
    self.secondLineView = [[UIView alloc]init];
    self.secondLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    
    self.thirdLineView = [[UIView alloc]init];
    self.thirdLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    
    self.fourthLineView = [[UIView alloc]init];
    self.fourthLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    
    self.level = 0;
    self.isExpand = NO;
}

- (void)setLevel:(NSInteger)level {
    [super setLevel:level];
    if (level == 0) {
        [self setupUIForFirstLevel];
    }else if (level == 1) {
        [self setupUIForSecondLevel];
    }else if (level == 2){
        [self setupUIForThirdLevel];
    }else {
        [self setupUIForFourthLevel];
    }
}

- (void)setupUIForFirstLevel {
    [self.secondLineView removeFromSuperview];
    [self.thirdLineView removeFromSuperview];
    [self.fourthLineView removeFromSuperview];
    
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    
    [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_left).offset(25);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    [self.firstLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.contentBgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.firstLineView.mas_right);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-42);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
    }];
    
    if (self.isExpand) {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表收起按钮正常态"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表收起按钮点击态"] forState:UIControlStateHighlighted];
    }else {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表展开按钮正常态"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表展开按钮点击态"] forState:UIControlStateHighlighted];
    }
}

- (void)setupUIForSecondLevel {
    [self.secondLineView removeFromSuperview];
    [self.thirdLineView removeFromSuperview];
    [self.fourthLineView removeFromSuperview];
    self.backgroundColor = [UIColor colorWithHexString:@"fcfcfc"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    
    [self.firstLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_left).offset(25 + 50);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self.contentView addSubview:self.secondLineView];
    [self.secondLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.expandButton.mas_centerX).offset(25);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.contentBgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondLineView.mas_right);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-42);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
    }];
    if (self.isExpand) {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表收起按钮正常态"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表收起按钮点击态"] forState:UIControlStateHighlighted];
    }else {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表展开按钮正常态"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表展开按钮点击态"] forState:UIControlStateHighlighted];
    }
}

- (void)setupUIForThirdLevel {
    [self.secondLineView removeFromSuperview];
    [self.thirdLineView removeFromSuperview];
    [self.fourthLineView removeFromSuperview];
    
    self.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    
    [self.firstLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.contentView addSubview:self.secondLineView];
    [self.secondLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_left).offset(25 + 100);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self.contentView addSubview:self.thirdLineView];
    [self.thirdLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.expandButton.mas_centerX).offset(25);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.contentBgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.thirdLineView.mas_right);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-42);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
    }];
    
    if (self.isExpand) {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表收起按钮正常态"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表收起按钮点击态"] forState:UIControlStateHighlighted];
    }else {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表展开按钮正常态"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表展开按钮点击态"] forState:UIControlStateHighlighted];
    }
}

- (void)setupUIForFourthLevel {
    [self.secondLineView removeFromSuperview];
    [self.thirdLineView removeFromSuperview];
    [self.fourthLineView removeFromSuperview];
    
    self.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];
    
    [self.firstLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.contentView addSubview:self.secondLineView];
    [self.secondLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.contentView addSubview:self.thirdLineView];
    [self.thirdLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(150);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_left).offset(25 + 150);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self.contentView addSubview:self.fourthLineView];
    [self.fourthLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.expandButton.mas_centerX).offset(25);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.contentBgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fourthLineView.mas_right);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-42);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
    }];
}

- (void)setIsExpand:(BOOL)isExpand {
    [super setIsExpand:isExpand];
    if (self.isExpand) {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表收起按钮正常态"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表收起按钮点击态"] forState:UIControlStateHighlighted];
    }else {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表展开按钮正常态"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"章节列表展开按钮点击态"] forState:UIControlStateHighlighted];
    }
}

- (void)setKnp:(GetKnpListRequestItem_knp *)knp {
    _knp = knp;
    self.expandButton.hidden = (knp.children.count == 0);
    if (self.level == 0) {
        [self setupTitleLabelLineSpacingWithLevel:0 textString:knp.name textWidth:SCREEN_WIDTH - 50 - 15 - 42];
        return;
    }
    if (self.level == 1) {
        [self setupTitleLabelLineSpacingWithLevel:1 textString:knp.name textWidth:SCREEN_WIDTH - 100 - 15 -42];
        return;
    }
    if (self.level == 2) {
        [self setupTitleLabelLineSpacingWithLevel:1 textString:knp.name textWidth:SCREEN_WIDTH - 150 - 15 -42];
        return;
    }
    if (self.level == 3) {
        [self setupTitleLabelLineSpacingWithLevel:1 textString:knp.name textWidth:SCREEN_WIDTH - 200 - 15 -42];
        return;
    }
}

- (void)setupTitleLabelLineSpacingWithLevel:(NSInteger)level textString:(NSString *)textString textWidth:(CGFloat)textWidth{
    CGSize titleSize = [textString boundingRectWithSize:CGSizeMake(textWidth , MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    CGFloat labelHeight = titleSize.height;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (labelHeight > self.titleLabel.font.lineHeight) {
        if (level == 0) {
            [paragraphStyle setLineSpacing:5.f];
        }else if (level == 1) {
            [paragraphStyle setLineSpacing:4.f];
        }else if (level == 2) {
            [paragraphStyle setLineSpacing:3.f];
        }else {
            [paragraphStyle setLineSpacing:2.f];
        }
    }else {
        [paragraphStyle setLineSpacing:0.f];
    }
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textString length])];
    self.titleLabel.attributedText = attributedString;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-42);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
    }];
}

- (void)setIsFirst:(BOOL)isFirst {
    _isFirst = isFirst;
    if (isFirst) {
        self.shadowView.hidden = YES;
    }else {
        self.shadowView.hidden = NO;
    }
}

- (void)setTreeExpandBlock:(ExpandBlock)block {
    self.expandBlock = block;
}

- (void)setTreeClickBlock:(ClickBlock)block {
    self.clickBlock = block;
}

#pragma mark - Actions
- (void)expandButtonAction {
    BLOCK_EXEC(self.expandBlock,self);
}

- (void)contentBgButtonTouchUpInsideAction {
    BLOCK_EXEC(self.clickBlock, self);
    self.accessoryImageView.highlighted = NO;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
}

- (void)contentBgButtonTouchDownAction {
    self.accessoryImageView.highlighted = YES;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
}

- (void)contentBgButtonTouchDragOutsideAction {
    self.accessoryImageView.highlighted = NO;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
}

- (void)contentBgButtonTouchDragInsideAction {
    self.accessoryImageView.highlighted = YES;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
}

- (void)contentBgButtonTouchCancelAction {
    self.accessoryImageView.highlighted = NO;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
}

@end
