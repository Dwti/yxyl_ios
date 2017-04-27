//
//  YXErrorTableViewCell.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXErrorTableViewCell.h"
#import "YXQADashLineView.h"
#import "YXQAUtils.h"
#import "YXDashLineCell.h"
#import "UIView+YXScale.h"

#define MAXWIDTH ([UIScreen mainScreen].bounds.size.width - 70 - 19 - 18)

static const CGFloat MaxCellHeight = 310;

@interface YXErrorTableViewCell()
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@property (nonatomic, strong) YXQADashLineView *lineView;
@property (nonatomic, strong) UIImageView *stemBgView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) YXDashLineCell *dottedLineView;

@end

@implementation YXErrorTableViewCell

#pragma mark- Get
- (YXDashLineCell *)dottedLineView
{
    if (!_dottedLineView) {
        _dottedLineView                         = [YXDashLineCell new];
        _dottedLineView.realWidth               = 8;
        _dottedLineView.dashWidth               = 6;
        _dottedLineView.preferedGapToCellBounds = 0;
        _dottedLineView.bHasShadow              = YES;
        _dottedLineView.realColor               = [UIColor whiteColor];
        _dottedLineView.selectionStyle          = UITableViewCellSelectionStyleNone;
    }
    return _dottedLineView;
}

- (UIImageView *)typeImageView
{
    if (!_typeImageView) {
        _typeImageView = [UIImageView new];
        _typeImageView.contentMode = UIViewContentModeLeft;
    }
    return _typeImageView;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton new];
        [_deleteButton setImage:[UIImage imageNamed:@"错"] forState:UIControlStateNormal];
        _deleteButton.enabled = YES;
        @weakify(self)
        [[_deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if (self.delegate) {
                [self.delegate deleteItem:self.item];
            }
        }];
    }
    return _deleteButton;
}

#pragma mark- Set
- (void)setShowSeparator:(BOOL)showSeparator
{
    _showSeparator = showSeparator;
    self.dottedLineView.hidden = !showSeparator;
}

#pragma mark-

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self addSubview:self.dottedLineView];
        [self.dottedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.stemBgView.mas_left).offset = 15;
            make.right.mas_equalTo(self.stemBgView.mas_right).offset = -15;
            make.top.mas_equalTo(self.stemBgView.mas_bottom).offset = -0.5;
            make.height.offset = 3;
        }];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];

    YXQADashLineView *line = [[YXQADashLineView alloc]init];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(34);
        make.right.mas_equalTo(-35);
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    self.lineView = line;
    
    UIImageView *stemBgView = [[UIImageView alloc] initWithImage:[UIImage yx_resizableImageNamed:@"通用背景"]];
    stemBgView.userInteractionEnabled = YES;
    [self.contentView addSubview:stemBgView];

    self.stemBgView = stemBgView;
    
    [stemBgView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 19;
        make.top.offset = 17;
    }];
    
    [stemBgView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -18;
        make.size.offset = 22;
        make.centerY.mas_equalTo(self.typeImageView);
    }];
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    self.htmlView.backgroundColor = [UIColor clearColor];
    self.htmlView.clipsToBounds = YES;
    [stemBgView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeImageView.mas_bottom).offset = 14;
        make.left.mas_equalTo(self.typeImageView);
        make.bottom.mas_equalTo(self.stemBgView.mas_bottom).offset = -17;
        make.right.mas_equalTo(self.deleteButton.mas_right);
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:MAXWIDTH];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [YXErrorTableViewCell totalHeightWithContentHeight:height dashHidden:self.dashLineHidden];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
}

- (void)setDashLineHidden:(BOOL)dashLineHidden{
    _dashLineHidden = dashLineHidden;
    if (dashLineHidden) {
        [self.lineView removeFromSuperview];
        [self.stemBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(35);
            make.top.mas_equalTo(-0.5).priorityHigh();
            make.right.mas_equalTo(-35);
            make.bottom.mas_equalTo(-2).priorityHigh();
        }];
    }
}

- (void)setItem:(QAQuestion *)item{
    if (self.item == item) {
        return;
    }
    _item = item;
    self.typeImageView.image = [UIImage imageNamed:item.typeString];
    [self.typeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 19;
        make.top.offset = 17;
        make.size.mas_equalTo(self.typeImageView.image.size);
    }];
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringForString:[item stemForMistake]];
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height dashHidden:(BOOL)dashHidden {
    CGFloat h = height + 40 + 14 + 16;
    h = MIN(h, MaxCellHeight);
    return ceilf(h);
}

+ (CGFloat)heightForString:(NSString *)string dashHidden:(BOOL)dashHidden{
    CGFloat height = [YXQACoreTextHelper heightForString:string constraintedToWidth:MAXWIDTH];
    height += 40 + 14 + 16;
    height = MIN(height, MaxCellHeight);
    return height;
}
@end
