//
//  MistakeTreeCell.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/28/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeTreeCell.h"

@interface MistakeTreeCell ()
@property (nonatomic, strong) UIButton *expandButton;
@property (nonatomic, strong) UIButton *contentButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;
@end

@implementation MistakeTreeCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupUI {
    [super setupUI];
    
    self.expandButton = [[UIButton alloc]init];
    [self.expandButton addTarget:self action:@selector(expandButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.expandButton];
    
    self.contentButton = [[UIButton alloc]init];
    [self.contentButton addTarget:self action:@selector(contentButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.contentButton];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.titleLabel.shadowColor = [UIColor colorWithHexString:@"ffff99"];
    self.titleLabel.shadowOffset = CGSizeMake(0, 1);
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.detailLabel.shadowColor = [UIColor colorWithHexString:@"ffff99"];
    self.detailLabel.shadowOffset = CGSizeMake(0, 1);
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.detailLabel];
    
    self.accessoryImageView = [[UIImageView alloc] init];
    self.accessoryImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.accessoryImageView.image = [UIImage imageNamed:@"蓝色右箭头"];
    [self.contentButton addSubview:self.accessoryImageView];
    
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
    } else {
        [self setupUIForFourthLevel];
    }
}

- (void)setupUIForFirstLevel {
    [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.contentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
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
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accessoryImageView.mas_centerY).offset(0);
        make.right.mas_equalTo(-10-15-28-10);
        make.width.mas_equalTo(30);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10+40+10+24);
        make.right.equalTo(self.detailLabel.mas_left).offset(-10);
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
    
    [self.contentButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"一级目录背景"] forState:UIControlStateNormal];
    [self.contentButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"一级目录背景按下"] forState:UIControlStateHighlighted];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.detailLabel.font = [UIFont systemFontOfSize:17];
}

- (void)setupUIForSecondLevel {
    [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.centerY.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    [self.contentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
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
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accessoryImageView.mas_centerY).offset(0);
        make.right.mas_equalTo(-10-10-20-23);
        make.width.mas_equalTo(30);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35+33+10+19);
        make.right.equalTo(self.detailLabel.mas_left).offset(-10);
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
    
    [self.contentButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"二级目录背景"] forState:UIControlStateNormal];
    [self.contentButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"二级目录背景按下"] forState:UIControlStateHighlighted];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.detailLabel.font = [UIFont systemFontOfSize:16];
}

- (void)setupUIForThirdLevel {
    [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.centerY.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.contentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.expandButton.mas_right).mas_offset(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(11);
    }];
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accessoryImageView.mas_centerY).offset(0);
        make.right.mas_equalTo(-10-10-21-25);
        make.width.mas_equalTo(30);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100+19);
        make.right.equalTo(self.detailLabel.mas_left).offset(-10);
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
    
    [self.contentButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"三级目录背景"] forState:UIControlStateNormal];
    [self.contentButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"三级目录背景按下"] forState:UIControlStateHighlighted];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setupUIForFourthLevel {
    [self.contentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(120);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(11);
    }];
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accessoryImageView.mas_centerY).offset(0);
        make.right.mas_equalTo(-10-10-21-25);
        make.width.mas_equalTo(30);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(120+19);
        make.right.equalTo(self.detailLabel.mas_left).offset(-10);
        make.top.mas_equalTo(11);
        make.bottom.mas_equalTo(-11-5);
    }];
    
    [self.contentButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"三级目录背景"] forState:UIControlStateNormal];
    [self.contentButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"三级目录背景按下"] forState:UIControlStateHighlighted];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
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
        } else if (self.level == 2) {
            [self.expandButton setBackgroundImage:[UIImage imageNamed:@"二级黄色-号"] forState:UIControlStateNormal];
            [self.expandButton setBackgroundImage:[UIImage imageNamed:@"二级黄色-号-按下"] forState:UIControlStateHighlighted];
        }
    }else {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级蓝色+号"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级蓝色+号-按下"] forState:UIControlStateHighlighted];
    }
}

- (void)setChapter:(MistakeChapterListRequestItem_chapter *)chapter {
    _chapter = chapter;
    self.titleLabel.text = chapter.name;
    self.detailLabel.text = chapter.count;
    self.expandButton.hidden = (chapter.children.count == 0);
}

- (void)setKnp:(MistakeKnpListRequestItem_knp *)knp {
    _knp = knp;
    self.titleLabel.text = knp.name;
    self.detailLabel.text = knp.count;
    self.expandButton.hidden = (knp.children.count == 0);
}

#pragma mark - Actions
- (void)expandButtonTapped {
    BLOCK_EXEC(self.expandBlock,self);
}

- (void)contentButtonTapped {
    BLOCK_EXEC(self.clickBlock, self);
}

@end
