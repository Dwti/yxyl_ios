//
//  QAClassifyImageOptionCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/5.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAClassifyImageOptionCell.h"

static const CGFloat kDefaultHeight = 80.f+10.f;

@interface QAClassifyImageOptionCell()
@property (nonatomic, strong) UIView *imageBgView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) NSString *imageUrlString;
@end

@implementation QAClassifyImageOptionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.imageBgView = [[UIView alloc]init];
    self.imageBgView.backgroundColor = [UIColor whiteColor];
    self.imageBgView.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    self.imageBgView.layer.borderWidth = 2;
    self.imageBgView.layer.cornerRadius = 6;
    [self.contentView addSubview:self.imageBgView];
    [self.imageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageBgView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
    
    self.deleteButton = [[UIButton alloc]init];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"归类题删除按钮正常态"] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"归类题删除按钮点击态"] forState:UIControlStateHighlighted];
    [self.deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    self.canDelete = NO;
}

- (void)deleteAction {
    BLOCK_EXEC(self.deleteBlock);
}

- (CGSize)defaultSize {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:self.imageUrlString]];
    SDImageCache *cache = [SDImageCache sharedImageCache];
    //此方法会先从memory中取。
    UIImage *image = [cache imageFromDiskCacheForKey:key];
    if (image) {
        return [self sizeForImage:image];
    }
    return CGSizeMake(kDefaultHeight, kDefaultHeight);
}

- (CGSize)sizeForImage:(UIImage *)image {
    CGFloat heightScale = image.size.height/(kDefaultHeight-10-4);
    CGFloat width = image.size.width/heightScale;
    width = MAX(width, kDefaultHeight-10-4);
    CGFloat maxWidth = SCREEN_WIDTH-34;
    if (self.canDelete) {
        maxWidth -= 10;
    }
    width = MIN(width, maxWidth);
    return CGSizeMake(width+10+4, kDefaultHeight);
}

#pragma mark - Setters
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.canDelete) {
        return;
    }
    if (selected) {
        self.imageBgView.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
        self.imageBgView.layer.shadowColor = [[UIColor colorWithHexString:@"89e00d"]colorWithAlphaComponent:0.24].CGColor;
        self.imageBgView.layer.shadowOffset = CGSizeMake(0, 0);
        self.imageBgView.layer.shadowRadius = 8;
        self.imageBgView.layer.shadowOpacity = 1;
    }else {
        self.imageBgView.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        self.imageBgView.layer.shadowOpacity = 0;
    }
}

- (void)setCanDelete:(BOOL)canDelete {
    [super setCanDelete:canDelete];
    self.deleteButton.hidden = !canDelete;
    if (canDelete) {
        self.imageBgView.layer.borderColor = [UIColor colorWithHexString:@"69ad0a"].CGColor;
    }else {
        self.imageBgView.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    }
}

- (void)setIsCorrect:(BOOL)isCorrect {
    [super setIsCorrect:isCorrect];
    if (isCorrect) {
        self.imageBgView.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    }else {
        self.imageBgView.layer.borderColor = [UIColor colorWithHexString:@"ff7a05"].CGColor;
    }
}

- (void)setOptionString:(NSString *)optionString {
    [super setOptionString:optionString];
    NSRange range = [optionString rangeOfString:@"src=\".+?\"" options:NSRegularExpressionSearch];
    NSRange urlRange = NSMakeRange(range.location+5, range.length-6);
    NSString *urlString = [optionString substringWithRange:urlRange];
    self.imageUrlString = urlString;
    
    WEAK_SELF
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        STRONG_SELF
        if (error) {
            return;
        }
        CGSize size = [self sizeForImage:image];
        BLOCK_EXEC(self.sizeChangedBlock,size);
    }];
}



@end
