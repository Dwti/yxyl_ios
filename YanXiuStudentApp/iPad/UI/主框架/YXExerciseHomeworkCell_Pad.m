//
//  YXExerciseHomeworkCell_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXExerciseHomeworkCell_Pad.h"
#import "YXUserManager.h"
#import "YXHotNumberLabel.h"

@interface YXExerciseHomeworkCell_Pad()
@property (nonatomic, strong) UIButton *functionButton;
@property (nonatomic, strong) id redLabel;

@end

@implementation YXExerciseHomeworkCell_Pad

#pragma mark- Get
- (NSString *)redNumber
{
    return [self.redLabel text];
}

#pragma mark- Set
- (void)setRedNumber:(NSString *)redNumber
{
    [self.redLabel setText:redNumber];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.functionButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"侧边栏按钮-激活"] forState:UIControlStateNormal];
        [self.functionButton setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
        [self.functionButton.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"ffff99"]];
    } else {
        [self.functionButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"侧边栏按钮-未激活"] forState:UIControlStateNormal];
        [self.functionButton setTitleColor:[UIColor colorWithHexString:@"006666"] forState:UIControlStateNormal];
        [self.functionButton.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"33ffff"]];
    }
    self.functionButton.selected = selected;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.functionButton = [[UIButton alloc]init];
    self.functionButton.userInteractionEnabled = NO;
    [self.functionButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"侧边栏按钮-未激活"] forState:UIControlStateNormal];
    [self.functionButton setTitle:@"练 习" forState:UIControlStateNormal];
    [self.functionButton setTitleColor:[UIColor colorWithHexString:@"006666"] forState:UIControlStateNormal];
    [self.functionButton.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"33ffff"]];
    self.functionButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.functionButton.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 8);
    self.functionButton.imageEdgeInsets = UIEdgeInsetsMake(-2, -30, 2, 30);
    [self.contentView addSubview:self.functionButton];
    [self.functionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
    
    
    _redLabel = [YXHotNumberLabel new];
    [self.functionButton addSubview:_redLabel];
    [_redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.functionButton.mas_right).offset = -24;
        make.centerY.mas_equalTo(self.contentView);
    }];
}

- (void)setType:(YXExerciseHomeworkType)type
{
    _type = type;
    if (type == YXExercise) {
        [self.functionButton setTitle:@"练 习" forState:UIControlStateNormal];
        [self.functionButton setImage:[UIImage yx_resizableImageNamed:@"练习icon未激活"] forState:UIControlStateNormal];
        [self.functionButton setImage:[UIImage yx_resizableImageNamed:@"练习icon已激活"] forState:UIControlStateSelected];
    } else {
        [self.functionButton setTitle:@"作 业" forState:UIControlStateNormal];
        [self.functionButton setImage:[UIImage yx_resizableImageNamed:@"作业icon未激活"] forState:UIControlStateNormal];
        [self.functionButton setImage:[UIImage yx_resizableImageNamed:@"作业icon已激活"] forState:UIControlStateSelected];
    }
}

@end
