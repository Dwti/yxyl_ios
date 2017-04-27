//
//  YXMineTableViewCell.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMineTableViewCell.h"
#import "UIColor+YXColor.h"
#import "YXCommonLabel.h"
#import "UIView+YXScale.h"
#import "YXDottedLineView.h"
#import "GlobalUtils.h"

NSString *const kYXMineCellIdentifier = @"kYXMineCellIdentifier";

@interface YXMineTableViewCell ()

@property (nonatomic, strong) UIImageView *httpImageView;
@property (nonatomic, strong) UIImageView *httpImageBGView;
@property (nonatomic, strong) YXCommonLabel *accessoryTextLabel;
@property (nonatomic, strong) YXDottedLineView *dottedLineView;
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation YXMineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setupSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSubviews
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"列表背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 30, 24, 30)]];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"列表背景-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 30, 24, 30)]];
    self.textLabel.textColor = [UIColor yx_colorWithHexString:@"805500"];
    self.textLabel.shadowColor = [UIColor yx_colorWithHexString:@"ffff99"];
    self.textLabel.shadowOffset = CGSizeMake(0, 1);
    self.textLabel.font = [UIFont boldSystemFontOfSize:17.f];
    self.textLabel.numberOfLines = 2.f;
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蓝色右箭头"]];
    self.accountLabel = [[UILabel alloc]init];
    self.accountLabel.textColor = [UIColor yx_colorWithHexString:@"805500"];
    self.accountLabel.shadowColor = [UIColor yx_colorWithHexString:@"ffff99"];
    self.accountLabel.shadowOffset = CGSizeMake(0, 1);
    self.accountLabel.font = [UIFont systemFontOfSize:13.f];
    self.accountLabel.numberOfLines = 2;
    [self.contentView addSubview:self.accountLabel];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor yx_colorWithHexString:@"805500"];
    self.nameLabel.shadowColor = [UIColor yx_colorWithHexString:@"ffff99"];
    self.nameLabel.shadowOffset = CGSizeMake(0, 1);
    self.nameLabel.font = [UIFont boldSystemFontOfSize:17.f];
    self.nameLabel.numberOfLines = 2;
    [self.contentView addSubview:self.nameLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
    CGRect frame = self.backgroundView.frame;
    if (self.showLine) {
        frame.size.height -= 1.f;
        self.backgroundView.frame = frame;
    }
    self.selectedBackgroundView.frame = self.backgroundView.frame;
    CGFloat originX = CGRectGetMinX(self.backgroundView.frame);
    CGFloat height = CGRectGetHeight(self.backgroundView.frame);
    
    if (self.showLine) {
        if (!self.dottedLineView) {
            self.dottedLineView = [[YXDottedLineView alloc] initWithFrame:CGRectMake(originX + 15 * [UIView scale], CGRectGetHeight(self.bounds) - 1, CGRectGetWidth(self.backgroundView.frame) - 30 * [UIView scale], 4.f) orientation:YXDottedLineOrientationHorizontal color:[UIColor whiteColor]];
            [self.dottedLineView drawWithDotLength:7.f intervalLength:7.f];
            [self addSubview:self.dottedLineView];
        }
        self.dottedLineView.hidden = NO;
    } else {
        self.dottedLineView.hidden = YES;
    }
    
    frame = self.imageView.frame;
    frame.origin.x = originX + 15.f;
    self.imageView.frame = frame;
    
    if (_httpImageView) {
        CGFloat imageInterval = height > 100.f ? 20.f:15.f;
        CGFloat imageHeight = height - imageInterval * 2.f;
        self.httpImageBGView.frame = CGRectMake(originX + imageInterval, imageInterval, imageHeight, imageHeight);
        _httpImageView.frame = CGRectInset(self.httpImageBGView.frame, 4.f, 4.f);
    } else {
        [_httpImageBGView removeFromSuperview];
        _httpImageBGView = nil;
    }
    
    CGFloat maxX = CGRectGetMaxX(self.backgroundView.frame) - 19.f * [UIView scale];
    
    CGFloat textOriginX = self.imageView.image ? CGRectGetMaxX(self.imageView.frame):(originX + 20 * [UIView scale]);
    textOriginX = _httpImageBGView ? (CGRectGetMaxX(_httpImageBGView.frame) + 5 * [UIView scale]):textOriginX;
    frame = self.textLabel.frame;
    if (self.isTextLabelInset) {
        frame.origin.x = textOriginX;
    } else {
        frame.origin.x = textOriginX + 10.f * [UIView scale];
    }
    frame.size.width = maxX - frame.origin.x - 30.f;
    self.textLabel.frame = frame;
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(frame.origin.x);
        make.width.mas_equalTo(frame.size.width);
        make.bottom.mas_equalTo(-self.frame.size.height/2-3);
    }];
    [self.accountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(frame.origin.x);
        make.width.mas_equalTo(frame.size.width);
        make.top.mas_equalTo(self.frame.size.height/2+3);
    }];
    
    if (self.accessoryViewHidden) {
        self.accessoryView.hidden = YES;
    } else {
        frame = self.accessoryView.frame;
        frame.origin.x = maxX - CGRectGetWidth(frame);
        self.accessoryView.frame = frame;
        maxX = CGRectGetMinX(self.accessoryView.frame);
    }
    
    if (_accessoryTextLabel) {
        _accessoryTextLabel.frame = CGRectMake(textOriginX + 50.f * [UIView scale], 0, maxX - textOriginX - 50 * [UIView scale] - 10.f, height);
    }
}

- (void)setTitle:(NSString *)title image:(UIImage *)image
{
    self.textLabel.text = title;
    self.imageView.image = image;
    self.nameLabel.text = nil;
    self.accountLabel.text = nil;
}
- (void)setTitle:(NSString *)title account:(NSString *)account
{
    self.nameLabel.text = title;
    // self.accountLabel.text = [NSString stringWithFormat:@"账号：%@",account];
    NSString *name = [YXUserManager sharedManager].userModel.passport.loginName;
    if (isEmpty(name)) {
        name = [YXUserManager sharedManager].userModel.mobile;
    }
    
    self.accountLabel.text = [NSString stringWithFormat:@"账号：%@",name];
    self.textLabel.text = nil;
}

- (void)updateWithAccessoryText:(NSString *)accessoryText
{
    self.accessoryTextLabel.text = accessoryText;
}

- (void)updateWithAccessoryCustomText:(NSString *)customText
{
    self.accessoryTextLabel.attributedText = [self attributedTextWithErrorExercisesNum:customText];
}

- (void)updateWithAccessoryText:(NSString *)accessoryText isBoldFont:(BOOL)isBoldFont
{
    if (isBoldFont) {
        self.accessoryTextLabel.font = [UIFont boldSystemFontOfSize:14.f];
    }
    self.accessoryTextLabel.text = accessoryText;
}

- (void)updateWithImageUrl:(NSString *)url
              defaultImage:(UIImage *)defaultImage
{
    NSURL *URL = nil;
    if ([url yx_isHttpLink]) {
        URL = [NSURL URLWithString:url];
    }
    if (URL || defaultImage) {
        [self.httpImageView sd_setImageWithURL:URL placeholderImage:defaultImage];
    } else {
        [_httpImageBGView removeFromSuperview];
        _httpImageBGView = nil;
        [_httpImageView removeFromSuperview];
        _httpImageView = nil;
        [self setNeedsDisplay];
    }
}

#pragma mark -

- (UILabel *)accessoryTextLabel
{
    if (!_accessoryTextLabel) {
        _accessoryTextLabel = [[YXCommonLabel alloc] init];
        _accessoryTextLabel.textAlignment = NSTextAlignmentRight;
        _accessoryTextLabel.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview:_accessoryTextLabel];
    }
    return _accessoryTextLabel;
}

- (UIImageView *)httpImageView
{
    if (!_httpImageView) {
        _httpImageView = [[UIImageView alloc] init];
        _httpImageView.clipsToBounds = YES;
        [self.contentView addSubview:_httpImageView];
    }
    return _httpImageView;
}

- (UIImageView *)httpImageBGView
{
    if (!_httpImageBGView) {
        _httpImageBGView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"首页头像边框"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16)]];
        _httpImageBGView.clipsToBounds = YES;
        [self.contentView addSubview:_httpImageBGView];
    }
    return _httpImageBGView;
}
#pragma mark - format data

- (NSAttributedString *)attributedTextWithErrorExercisesNum:(NSString *)num {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:num attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.f], NSShadowAttributeName: [self textShadow], NSForegroundColorAttributeName: [UIColor yx_colorWithHexString:@"b3476b"]}];
    return attributedText;
}

- (NSShadow *)textShadow {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, 1); //垂直投影
    shadow.shadowColor = [UIColor yx_colorWithHexString:@"ffff99"];
    return shadow;
}


@end
