//
//  QAPhotoBrowseTopBarView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAPhotoBrowseTopBarView.h"

@interface QAPhotoBrowseTopBarView()
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation QAPhotoBrowseTopBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [[UIColor colorWithHexString:@"89e00d"]colorWithAlphaComponent:0.86];
    UIButton *backButton = [[UIButton alloc]init];
    [backButton setImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 26, 26)] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    
    self.deleteButton = [[UIButton alloc]init];
    [self.deleteButton setImage:[UIImage imageNamed:@"删除图片按钮正常态"] forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"删除图片按钮点击态"] forState:UIControlStateHighlighted];
    [self.deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont fontWithName:YXFontMetro_DemiBold size:21];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (void)setCanDelete:(BOOL)canDelete {
    _canDelete = canDelete;
    self.deleteButton.hidden = !canDelete;
}

- (void)updateWithCurrentIndex:(NSInteger)index total:(NSInteger)total {
    NSString *string = [NSString stringWithFormat:@"%@ / %@",@(index+1),@(total)];
    NSRange range = [string rangeOfString:@"/"];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:string];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:YXFontMetro_Regular size:21] range:range];
    self.titleLabel.attributedText = attrStr;
}

- (void)backAction {
    BLOCK_EXEC(self.exitBlock);
}

- (void)deleteAction {
    BLOCK_EXEC(self.deleteBlock);
}

@end
