//
//  YXExerciseChooseChapterKnp_ChooseVolumeCell.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 1/29/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "YXExerciseChooseChapterKnp_ChooseVolumeCell.h"

@interface YXExerciseChooseChapterKnp_ChooseVolumeCell ()

@property (nonatomic, strong) UIImageView *accessoryImageView;

@end

@implementation YXExerciseChooseChapterKnp_ChooseVolumeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage yx_createImageWithColor:[UIColor redColor]]];
        [self.contentView addSubview:self.accessoryImageView];
    }
    return self;
}

- (void)layoutSubviews {
    if (self.accessoryImageView.hidden) {
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 0));
        }];
    } else {
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(self.accessoryImageView.mas_left);
        }];
    }
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.textLabel.mas_centerY);
        make.right.mas_equalTo(-14);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.textLabel.textColor = [UIColor colorWithHexString:@"336600"];
        self.accessoryImageView.hidden = NO;
    } else {
        self.textLabel.textColor = [UIColor whiteColor];
        self.accessoryImageView.hidden = YES;
    }
    [self layoutSubviews];
}

@end
