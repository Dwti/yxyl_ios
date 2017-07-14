//
//  QAClassifyTextOptionCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/5.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAClassifyTextOptionCell.h"

@interface QAClassifyTextOptionCell()
@property (nonatomic, strong) UIView *labelBgView;
@property (nonatomic, strong) DTAttributedLabel *optionLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation QAClassifyTextOptionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.labelBgView = [[UIView alloc]init];
    self.labelBgView.backgroundColor = [UIColor whiteColor];
    self.labelBgView.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    self.labelBgView.layer.borderWidth = 2;
    self.labelBgView.layer.cornerRadius = 6;
    [self.contentView addSubview:self.labelBgView];
    [self.labelBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    self.optionLabel = [[DTAttributedLabel alloc]init];
    self.optionLabel.backgroundColor = [UIColor clearColor];
    [self.labelBgView addSubview:self.optionLabel];
    [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(17, 19, 17, 15));
    }];
    
    self.deleteButton = [[UIButton alloc]init];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"归类题选择后删除按钮正常态"] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"归类题选择后删除按钮点击态"] forState:UIControlStateHighlighted];
    [self.deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    self.canDelete = NO;
}

- (void)deleteAction {
    BLOCK_EXEC(self.deleteBlock);
}

- (CGSize)defaultSize {
    CGFloat maxWidth = SCREEN_WIDTH-64;
    if (self.canDelete) {
        maxWidth -= 10;
    }
    DTAttributedLabel *label = [[DTAttributedLabel alloc]initWithFrame:CGRectMake(0, 0, maxWidth, 500)];
    label.attributedString = self.optionLabel.attributedString;
    [label sizeToFit];
    return CGSizeMake(label.width+30+4+10, label.height+30+4+10);
}

#pragma mark - Setters
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.canDelete) {
        return;
    }
    if (selected) {
        self.labelBgView.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
        self.labelBgView.layer.shadowColor = [[UIColor colorWithHexString:@"89e00d"]colorWithAlphaComponent:0.24].CGColor;
        self.labelBgView.layer.shadowOffset = CGSizeMake(0, 0);
        self.labelBgView.layer.shadowRadius = 8;
        self.labelBgView.layer.shadowOpacity = 1;
    }else {
        self.labelBgView.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        self.labelBgView.layer.shadowOpacity = 0;
    }
}

- (void)setCanDelete:(BOOL)canDelete {
    [super setCanDelete:canDelete];
    self.deleteButton.hidden = !canDelete;
    [self updateOptionLabel];
    if (canDelete) {
        self.labelBgView.backgroundColor = [UIColor colorWithHexString:@"69ad0a"];
        self.labelBgView.layer.borderColor = [UIColor clearColor].CGColor;
    }else {
        self.labelBgView.backgroundColor = [UIColor whiteColor];
        self.labelBgView.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    }
}

- (void)setIsCorrect:(BOOL)isCorrect {
    [super setIsCorrect:isCorrect];
    if (isCorrect) {
        self.labelBgView.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    }else {
        self.labelBgView.layer.borderColor = [UIColor colorWithHexString:@"ff7a05"].CGColor;
    }
}

- (void)setOptionString:(NSString *)optionString {
    [super setOptionString:optionString];
    [self updateOptionLabel];
}

- (void)updateOptionLabel {
    if (self.canDelete) {
        NSDictionary *dic = [YXQACoreTextHelper defaultOptionsForClassifyOptionsInClass];
        self.optionLabel.attributedString = [YXQACoreTextHelper attributedStringWithString:self.optionString options:dic];
    }else {
        NSDictionary *dic = [YXQACoreTextHelper defaultOptionsForClassifyOptions];
        self.optionLabel.attributedString = [YXQACoreTextHelper attributedStringWithString:self.optionString options:dic];
    }
}

@end
