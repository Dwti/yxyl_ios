//
//  AlbumListTableViewCell.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/4/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "AlbumListTableViewCell.h"

@implementation AlbumListModel : NSObject
@end

@interface AlbumListTableViewCell ()
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UIImageView *accessoryImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation AlbumListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupUI {
    self.thumbImageView = [[UIImageView alloc] init];
    self.thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.thumbImageView.layer.cornerRadius = 10;
    self.thumbImageView.layer.masksToBounds = YES;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"000000"];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"979797"];
    self.subTitleLabel.font = [UIFont systemFontOfSize:12];
    
    self.accessoryImageView = [[UIImageView alloc] init];
    self.accessoryImageView.image = [UIImage imageNamed:@"确定"];
    self.accessoryImageView.hidden = YES;
}

- (void)setupLayout {
    [self addSubview:self.thumbImageView];
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(70);
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thumbImageView.mas_right).offset(10);
        make.bottom.equalTo(self.mas_centerY).offset(-5);
    }];
    
    [self addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thumbImageView.mas_right).offset(10);
        make.top.equalTo(self.mas_centerY).offset(5);
    }];
    
    [self addSubview:self.accessoryImageView];
    [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
}

- (void)setModel:(AlbumListModel *)model {
    _model = model;
    
    self.thumbImageView.image = model.assetInfo.thumbnail;
    self.titleLabel.text = model.assetInfo.name;
    self.subTitleLabel.text = [NSString stringWithFormat:@"%ld张", (long)model.assetInfo.count];
    self.accessoryImageView.hidden = !model.isSelected;
}

@end
