//
//  YXUnfinishedHeaderCell.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/22/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXUnfinishedHeaderCell.h"

@interface YXUnfinishedHeaderCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;
@property (nonatomic, strong) UIButton *clickButton;
@end

@implementation YXUnfinishedHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    self.backgroundColor = [UIColor clearColor];
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor colorWithHexString:@"008080"];
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"00cccc"];
    self.nameLabel.layer.shadowColor = [UIColor colorWithHexString:@"005959"].CGColor;
    self.nameLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.nameLabel.layer.shadowOpacity = 1;
    self.nameLabel.layer.shadowRadius = 0;
    [containerView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
    
    
    self.accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蓝色右箭头"]];
    [containerView addSubview:self.accessoryImageView];
    [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
    }];
    
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = [UIColor colorWithHexString:@"007373"];
    [containerView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];
    
    self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [containerView addSubview:self.clickButton];
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 2, 0));
    }];
    [self.clickButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUnfinishedCount:(NSInteger)unfinishedCount {
    _unfinishedCount = unfinishedCount;
    NSString *str = [NSString stringWithFormat:@"共有 %@ 篇待完成作业", @(unfinishedCount)];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedText setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"ffdb4d"],
                                    NSFontAttributeName: [UIFont boldSystemFontOfSize:16]}
                            range:[str rangeOfString:[NSString stringWithFormat:@"%@", @(unfinishedCount)]]];
    self.nameLabel.attributedText = attributedText;
}

- (void)clickAction {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
