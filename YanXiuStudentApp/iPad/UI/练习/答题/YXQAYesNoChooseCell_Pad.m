//
//  YXQAYesNoChooseCell_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAYesNoChooseCell_Pad.h"

@interface YXQAYesNoChooseCell_Pad()
@property (nonatomic, strong) UIImageView *singleAView;
@property (nonatomic, strong) UIButton *yesButton;
@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, strong) UIImageView *wrongMarkView;
@property (nonatomic, strong) UIImageView *correctMarkView;
@end

@implementation YXQAYesNoChooseCell_Pad


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    YXSmartDashLineView *line = [[YXSmartDashLineView alloc]init];
    line.dashWidth = 5;
    line.gapWidth = 2;
    line.lineColor = [UIColor colorWithHexString:@"ccc4a3"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    self.singleAView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"A"]];
    [self.contentView addSubview:self.singleAView];
    [self.singleAView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(39);
        make.top.mas_equalTo(22);
        make.size.mas_equalTo(CGSizeMake(26, 28));
    }];
    
    self.yesButton = [[UIButton alloc]init];
    [self setupButton:self.yesButton withScheme:YXQAYesNoSchemeDefault];
    [self.yesButton setTitle:@"正确" forState:UIControlStateNormal];
    self.yesButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.yesButton addTarget:self action:@selector(yesAction) forControlEvents:UIControlEventTouchUpInside];
    self.yesButton.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    [self.contentView addSubview:self.yesButton];
    
    self.noButton = [[UIButton alloc]init];
    [self setupButton:self.noButton withScheme:YXQAYesNoSchemeDefault];
    [self.noButton setTitle:@"错误" forState:UIControlStateNormal];
    self.noButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.noButton addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
    self.noButton.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    [self.contentView addSubview:self.noButton];
    
    UIView *gap = [[UIView alloc]init];
    gap.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:gap];
    
    [self.yesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-149).priorityHigh();
        make.height.mas_equalTo(53);
    }];
    [gap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.yesButton.mas_left);
        make.width.mas_equalTo(45);
    }];
    [self.noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(190).priorityHigh();
        make.width.mas_equalTo(self.yesButton.mas_width);
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

#pragma mark - Setter
- (void)setMyAnswerArray:(NSMutableArray *)myAnswerArray{
    _myAnswerArray = myAnswerArray;
    if ([_myAnswerArray.firstObject boolValue]) {
        [self setupButton:self.yesButton withScheme:YXQAYesNoSchemeDefault];
        [self setupButton:self.noButton withScheme:YXQAYesNoSchemeWrong];
    }
    if ([_myAnswerArray.lastObject boolValue]) {
        [self setupButton:self.yesButton withScheme:YXQAYesNoSchemeCorrect];
        [self setupButton:self.noButton withScheme:YXQAYesNoSchemeDefault];
    }
}

#pragma mark -
- (void)yesAction{
    if ([_myAnswerArray[1] boolValue]) {
        [self resetYesNoState];
        return;
    }
    [self setupButton:self.yesButton withScheme:YXQAYesNoSchemeCorrect];
    [self setupButton:self.noButton withScheme:YXQAYesNoSchemeDefault];
    [_myAnswerArray replaceObjectAtIndex:0 withObject:@NO];
    [_myAnswerArray replaceObjectAtIndex:1 withObject:@YES];
    [self.delegate autoGoNextGoGoGo];
}

- (void)noAction{
    if ([_myAnswerArray[0] boolValue]) {
        [self resetYesNoState];
        return;
    }
    [self setupButton:self.yesButton withScheme:YXQAYesNoSchemeDefault];
    [self setupButton:self.noButton withScheme:YXQAYesNoSchemeWrong];
    [_myAnswerArray replaceObjectAtIndex:0 withObject:@YES];
    [_myAnswerArray replaceObjectAtIndex:1 withObject:@NO];
    [self.delegate autoGoNextGoGoGo];
}

- (void)resetYesNoState {
    [_myAnswerArray removeAllObjects];
    [_myAnswerArray addObject:@NO];
    [_myAnswerArray addObject:@NO];
    self.item.myAnswers = [NSMutableArray arrayWithArray:_myAnswerArray];
    [self setupButton:self.yesButton withScheme:YXQAYesNoSchemeDefault];
    [self setupButton:self.noButton withScheme:YXQAYesNoSchemeDefault];
}

- (void)setupButton:(UIButton *)button withScheme:(YXQAYesNoSchemeType)scheme{
    if (scheme == YXQAYesNoSchemeCorrect) {
        [button setBackgroundImage:[UIImage yx_resizableImageNamed:@"正确icon背景"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage yx_resizableImageNamed:@"正确icon背景-按下"] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithHexString:@"80334d"] forState:UIControlStateNormal];
        [button.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"ffe5ee"]];
    }else if (scheme == YXQAYesNoSchemeWrong){
        [button setBackgroundImage:[UIImage yx_resizableImageNamed:@"错误按钮背景"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage yx_resizableImageNamed:@"错误按钮背景-按下"] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithHexString:@"006666"] forState:UIControlStateNormal];
        [button.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"33ffff"]];
    }else{
        [button setBackgroundImage:[UIImage yx_resizableImageNamed:@"默认按钮背景"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage yx_resizableImageNamed:@"默认按钮背景-按下"] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
        [button.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"ffff99"]];
    }
}

#pragma mark - for jiexi
- (void)updateWithMyAnswer:(NSArray *)myAnswerArray correctAnswer:(NSArray *)correctAnswerArray{
    [self setupButton:self.noButton withScheme:YXQAYesNoSchemeDefault];
    [self setupButton:self.yesButton withScheme:YXQAYesNoSchemeDefault];
    self.wrongMarkView.image = nil;
    self.correctMarkView.image = nil;
    if ([myAnswerArray.firstObject boolValue]) {
        [self setupButton:self.noButton withScheme:YXQAYesNoSchemeWrong];
        self.wrongMarkView.image = [UIImage imageNamed:@"出题-判断题-叉子-红"];
    }
    if ([myAnswerArray.lastObject boolValue]) {
        [self setupButton:self.yesButton withScheme:YXQAYesNoSchemeCorrect];
        self.correctMarkView.image = [UIImage imageNamed:@"出题-判断题-叉子-红"];
    }
    if ([correctAnswerArray.firstObject boolValue]) {
        self.wrongMarkView.image = [UIImage imageNamed:@"出题-判断题-对勾-绿"];
    }
    if ([correctAnswerArray.lastObject boolValue]) {
        self.correctMarkView.image = [UIImage imageNamed:@"出题-判断题-对勾-绿"];
    }
}

@end
