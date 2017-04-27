//
//  YXYesNoChooseView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/14.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXQAYesNoChooseCell.h"
#import "YXQADashLineView.h"

typedef NS_ENUM(NSUInteger, YXButtonScheme) {
    ECorrect,
    EWrong,
    EDefault
};

@interface YXQAYesNoChooseCell()
@property (nonatomic, strong) UIImageView *singleAView;
@property (nonatomic, strong) UIButton *yesButton;
@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, strong) UIImageView *wrongMarkView;
@property (nonatomic, strong) UIImageView *correctMarkView;
@end

@implementation YXQAYesNoChooseCell

- (void)setMyAnswerArray:(NSMutableArray *)myAnswerArray{
    _myAnswerArray = myAnswerArray;
    if ([_myAnswerArray.firstObject boolValue]) {
        [self setupButton:self.yesButton withScheme:EDefault];
        [self setupButton:self.noButton withScheme:EWrong];
    }
    if ([_myAnswerArray.lastObject boolValue]) {
        [self setupButton:self.yesButton withScheme:ECorrect];
        [self setupButton:self.noButton withScheme:EDefault];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    YXQADashLineView *line = [[YXQADashLineView alloc]init];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    self.singleAView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"A"]];
    [self.contentView addSubview:self.singleAView];
    [self.singleAView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(22);
        make.size.mas_equalTo(CGSizeMake(26, 28));
    }];
    
    self.yesButton = [[UIButton alloc]init];
    [self setupButton:self.yesButton withScheme:EDefault];
    [self.yesButton setTitle:@"正确" forState:UIControlStateNormal];
    self.yesButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.yesButton addTarget:self action:@selector(yesAction) forControlEvents:UIControlEventTouchUpInside];
    self.yesButton.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    [self.contentView addSubview:self.yesButton];
    
    self.noButton = [[UIButton alloc]init];
    [self setupButton:self.noButton withScheme:EDefault];
    [self.noButton setTitle:@"错误" forState:UIControlStateNormal];
    self.noButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.noButton addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
    self.noButton.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    [self.contentView addSubview:self.noButton];
    
    UIView *gap = [[UIView alloc]init];
    gap.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:gap];
    
    [self.noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-17);
        make.height.mas_equalTo(53);
    }];
    [gap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.noButton.mas_left);
        make.width.mas_equalTo(6);
    }];
    [self.yesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.singleAView.mas_right).mas_offset(12);
        make.width.mas_equalTo(self.noButton.mas_width);
        make.right.mas_equalTo(gap.mas_left);
    }];
    
    self.wrongMarkView = [[UIImageView alloc]init];
    [self.noButton addSubview:self.wrongMarkView];
    [self.wrongMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-8);
        make.right.mas_equalTo(8);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.correctMarkView = [[UIImageView alloc]init];
    [self.yesButton addSubview:self.correctMarkView];
    [self.correctMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-8);
        make.right.mas_equalTo(8);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)yesAction{
    if ([_myAnswerArray[1] boolValue]) {
        [self resetYesNoState];
        return;
    }
    [self setupButton:self.yesButton withScheme:ECorrect];
    [self setupButton:self.noButton withScheme:EDefault];
    [_myAnswerArray replaceObjectAtIndex:0 withObject:@NO];
    [_myAnswerArray replaceObjectAtIndex:1 withObject:@YES];
    [self.delegate autoGoNextGoGoGo];
    [self executeRedoStatusDelegate];
}

- (void)noAction{
    if ([_myAnswerArray[0] boolValue]) {
        [self resetYesNoState];
        return;
    }
    [self setupButton:self.yesButton withScheme:EDefault];
    [self setupButton:self.noButton withScheme:EWrong];
    [_myAnswerArray replaceObjectAtIndex:0 withObject:@YES];
    [_myAnswerArray replaceObjectAtIndex:1 withObject:@NO];
    [self.delegate autoGoNextGoGoGo];
    [self executeRedoStatusDelegate];
}

- (void)resetYesNoState {
    [_myAnswerArray removeAllObjects];
    [_myAnswerArray addObject:@NO];
    [_myAnswerArray addObject:@NO];
    [self setupButton:self.yesButton withScheme:EDefault];
    [self setupButton:self.noButton withScheme:EDefault];
    [self executeRedoStatusDelegate];
}

- (void)executeRedoStatusDelegate {
    if (self.redoStatusDelegate && [self.redoStatusDelegate respondsToSelector:@selector(updateRedoStatus)]) {
        [self.redoStatusDelegate updateRedoStatus];
    }
}

- (void)setupButton:(UIButton *)button withScheme:(YXButtonScheme)scheme{
    if (scheme == ECorrect || scheme == EWrong) {
        [button setBackgroundImage:[UIImage stretchImageNamed:@"正确按钮背景"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage stretchImageNamed:@"正确按钮背景-按下"] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithHexString:@"006666"] forState:UIControlStateNormal];
        button.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
        button.titleLabel.layer.shadowRadius = 0;
        button.titleLabel.layer.shadowOpacity = 1;
        button.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"33ffff"].CGColor;
    } else {
        [button setBackgroundImage:[UIImage stretchImageNamed:@"默认按钮背景"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage stretchImageNamed:@"默认按钮背景-按下"] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
        button.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
        button.titleLabel.layer.shadowRadius = 0;
        button.titleLabel.layer.shadowOpacity = 1;
        button.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    }
}

#pragma mark - for jiexi
- (void)updateWithMyAnswer:(NSArray *)myAnswerArray correctAnswer:(NSArray *)correctAnswerArray{
    [self setupButton:self.noButton withScheme:EDefault];
    [self setupButton:self.yesButton withScheme:EDefault];
    self.wrongMarkView.image = nil;
    self.correctMarkView.image = nil;
    if ([myAnswerArray.firstObject boolValue]) {
        if ([myAnswerArray.firstObject boolValue]) {
            [self setupButton:self.noButton withScheme:EWrong];
            self.wrongMarkView.image = [UIImage imageNamed:@"出题-判断题-叉子-红"];
        }
        if ([correctAnswerArray.firstObject boolValue]) {
            self.wrongMarkView.image = [UIImage imageNamed:@"出题-判断题-对勾-绿"];
        }
    }
    
    if ([myAnswerArray.lastObject boolValue]) {
        if ([myAnswerArray.lastObject boolValue]) {
            [self setupButton:self.yesButton withScheme:ECorrect];
            self.correctMarkView.image = [UIImage imageNamed:@"出题-判断题-叉子-红"];
        }
        if ([correctAnswerArray.lastObject boolValue]) {
            self.correctMarkView.image = [UIImage imageNamed:@"出题-判断题-对勾-绿"];
        }
    }
    
    if (![myAnswerArray.firstObject boolValue] && ![myAnswerArray.lastObject boolValue]) {
        if ([correctAnswerArray.firstObject boolValue]) {
            self.wrongMarkView.image = [UIImage imageNamed:@"出题-判断题-对勾-绿"];
        }
        if ([correctAnswerArray.lastObject boolValue]) {
            self.correctMarkView.image = [UIImage imageNamed:@"出题-判断题-对勾-绿"];
        }
    }
}

@end
