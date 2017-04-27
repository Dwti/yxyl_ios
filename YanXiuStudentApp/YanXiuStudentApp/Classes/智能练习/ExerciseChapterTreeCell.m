//
//  ExerciseChapterTreeCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseChapterTreeCell.h"

@interface ExerciseChapterTreeCell ()
@property (nonatomic, strong) UIButton *expandButton;
@property (nonatomic, strong) UIButton *contentBgButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;

@property (nonatomic, copy) ExpandBlock expandBlock;
@property (nonatomic, copy) ClickBlock clickBlock;
@end

@implementation ExerciseChapterTreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUI {
    [super setupUI];
    
    self.expandButton = [[UIButton alloc]init];
    [self.expandButton addTarget:self action:@selector(expandButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.expandButton];
    
    self.contentBgButton = [[UIButton alloc]init];
    [self.contentBgButton addTarget:self action:@selector(contentBgButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.contentBgButton];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.titleLabel.shadowColor = [UIColor colorWithHexString:@"ffff99"];
    self.titleLabel.shadowOffset = CGSizeMake(0, 1);
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    self.accessoryImageView = [[UIImageView alloc] init];
    self.accessoryImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.accessoryImageView.image = [UIImage imageNamed:@"蓝色右箭头"];
    [self.contentBgButton addSubview:self.accessoryImageView];
    
    self.level = 0;
    self.isExpand = NO;
}

- (void)setLevel:(NSInteger)level {
    [super setLevel:level];
    if (level == 0) {
        [self setupUIForFirstLevel];
    }else if (level == 1) {
        [self setupUIForSecondLevel];
    }else {
        [self setupUIForThirdLevel];
    }
}

- (void)setupUIForFirstLevel {
    [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.contentBgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.expandButton.mas_right).mas_offset(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(22);
    }];
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-2);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10+40+10+24);
        make.right.mas_equalTo(-10-15-28-10);
        make.top.mas_equalTo(18);
        make.bottom.mas_equalTo(-22-5);
    }];
    
    if (self.isExpand) {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级黄色-号"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级黄色-号-按下"] forState:UIControlStateHighlighted];
    }else {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级蓝色+号"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级蓝色+号-按下"] forState:UIControlStateHighlighted];
    }

    [self.contentBgButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"一级目录背景"] forState:UIControlStateNormal];
    [self.contentBgButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"一级目录背景按下"] forState:UIControlStateHighlighted];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
}

- (void)setupUIForSecondLevel {
    [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.centerY.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    [self.contentBgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.expandButton.mas_right).mas_offset(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(11);
    }];
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-0);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35+33+10+19);
        make.right.mas_equalTo(-10-20-23-10);
        make.top.mas_equalTo(11);
        make.bottom.mas_equalTo(-11-5);
    }];
    
    if (self.isExpand) {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"二级黄色-号"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"二级黄色-号-按下"] forState:UIControlStateHighlighted];
    }else {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级蓝色+号"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级蓝色+号-按下"] forState:UIControlStateHighlighted];
    }
    
    [self.contentBgButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"二级目录背景"] forState:UIControlStateNormal];
    [self.contentBgButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"二级目录背景按下"] forState:UIControlStateHighlighted];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
}

- (void)setupUIForThirdLevel {
    [self.contentBgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(11);
    }];
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100+19);
        make.right.mas_equalTo(-10-25-21-10);
        make.top.mas_equalTo(11);
        make.bottom.mas_equalTo(-11-5);
    }];
    
    [self.contentBgButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"三级目录背景"] forState:UIControlStateNormal];
    [self.contentBgButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"三级目录背景按下"] forState:UIControlStateHighlighted];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
}

- (void)setIsExpand:(BOOL)isExpand {
    [super setIsExpand:isExpand];
    if (self.isExpand) {
        if (self.level == 0) {
            [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级黄色-号"] forState:UIControlStateNormal];
            [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级黄色-号-按下"] forState:UIControlStateHighlighted];
        }else if (self.level == 1) {
            [self.expandButton setBackgroundImage:[UIImage imageNamed:@"二级黄色-号"] forState:UIControlStateNormal];
            [self.expandButton setBackgroundImage:[UIImage imageNamed:@"二级黄色-号-按下"] forState:UIControlStateHighlighted];
        }
    }else {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级蓝色+号"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级蓝色+号-按下"] forState:UIControlStateHighlighted];
    }
}

- (void)setChapter:(GetChapterListRequestItem_chapter *)chapter {
    _chapter = chapter;
    self.titleLabel.text = chapter.name;
    self.expandButton.hidden = (chapter.children.count == 0);
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

- (void)contentBgButtonAction {
    BLOCK_EXEC(self.clickBlock, self);
}


@end
