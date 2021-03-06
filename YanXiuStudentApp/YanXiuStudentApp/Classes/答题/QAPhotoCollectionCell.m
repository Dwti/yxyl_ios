//
//  QAPhotoCollectionCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAPhotoCollectionCell.h"

@interface QAPhotoCollectionCell()
@property (nonatomic, strong) UIImageView *collectionImageView;
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation QAPhotoCollectionCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"dbdddb"];
    }else {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.collectionImageView = [[UIImageView alloc]init];
    self.collectionImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.collectionImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.collectionImageView];
    [self.collectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"默认相册胶卷"]];
    imageView.frame = CGRectMake(0, 0, 60, 60);
    self.collectionImageView.layer.mask = imageView.layer;
    
    self.tagImageView = [[UIImageView alloc]init];
    self.tagImageView.layer.cornerRadius = 10;
    self.tagImageView.clipsToBounds = YES;
    self.tagImageView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    [self.contentView addSubview:self.tagImageView];
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionImageView.mas_top);
        make.right.mas_equalTo(self.collectionImageView.mas_right).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UIImageView *markImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"相机胶卷所选胶卷状态标识"]];
    [self.tagImageView addSubview:markImageView];
    [markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:17];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.collectionImageView.mas_right).mas_offset(15);
        make.centerY.mas_equalTo(0);
    }];
    self.bottomLineView = [[UIView alloc]init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"dbdddb"];
    [self.contentView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(90);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setIsCurrent:(BOOL)isCurrent {
    _isCurrent = isCurrent;
    self.tagImageView.hidden = !isCurrent;
}

- (void)setBottomLineHidden:(BOOL)bottomLineHidden {
    _bottomLineHidden = bottomLineHidden;
    self.bottomLineView.hidden = bottomLineHidden;
}

- (void)setCollection:(PHAssetCollection *)collection {
    _collection = collection;
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    if (assetsFetchResults.count==0) {
        self.collectionImageView.image = [UIImage imageNamed:@"默认相册胶卷"];
    }else {
        PHAsset *asset = assetsFetchResults[0];
        CGSize size = CGSizeMake(120, 120);
        WEAK_SELF
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            STRONG_SELF
            self.collectionImageView.image = result;
        }];
    }
    NSString *countStr = [NSString stringWithFormat:@"%@",@(assetsFetchResults.count)];
    NSString *totalStr = [NSString stringWithFormat:@"%@ (%@)",collection.localizedTitle,countStr];
    NSRange range = [totalStr rangeOfString:countStr];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:YXFontMetro_Regular size:17] range:range];
    self.nameLabel.attributedText = attrStr;
}

@end
