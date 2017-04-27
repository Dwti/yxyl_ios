//
//  YXPhotoCollectionViewCell.m
//  ImagePickerDemo
//
//  Created by wd on 15/9/22.
//  Copyright © 2015年 wd. All rights reserved.
//

#import "YXPhotoCollectionViewCell.h"
@interface YXPhotoCollectionViewCell ()
@property(nonatomic, strong) UIImageView * photoView;
@property(nonatomic, strong) UIButton*     selectButton;
@end

@implementation YXPhotoCollectionViewCell
- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}
- (void)setupViews
{
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.photoView.layer.cornerRadius = 6;
    [self.contentView addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
    self.photoView.layer.cornerRadius = 6;
    self.photoView.clipsToBounds = YES;
    
    
    self.selectButton  = [[UIButton alloc] initWithFrame:CGRectZero];
    self.selectButton.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.selectButton];
    UIImage *dImage = [[UIImage imageNamed:@"缩略图默认边框"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    UIImage *sImage = [[UIImage imageNamed:@"缩略图选中状态边框"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    
    dImage = [UIImage imageNamed:@"缩略图默认边框"];
    sImage = [UIImage imageNamed:@"缩略图选中状态边框"];
    [self.selectButton setBackgroundImage:dImage forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage
     :sImage forState:UIControlStateSelected];
    [self.selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];    
}

- (void)setPhotoModel:(YXPhotoModel *)photoModel
{
    _photoModel = photoModel;
    if (photoModel) {
        self.photoView.image = _photoModel.thumbImage;
        self.photoView.layer.cornerRadius = 6;
        [self.photoView setNeedsDisplay];
        self.selectButton.selected = _photoModel.isSelect;
    }
}
- (void)selectButtonClicked:(UIButton *)sender
{
    if (self.selectHandle) {
        self.selectHandle(self.photoModel,sender);
    }
}
- (void)remakeFrameWithIndex:(NSInteger)nindex
{
//    @weakify(self);
//    CGFloat leftOffset = 0;
//    CGFloat rightOffset = 0;
//    CGFloat topOffset = 0;
//    CGFloat bottomOffset = 0;
//    if (nindex % 4 == 0) {
//        leftOffset = 4;
//        rightOffset = 2;
//    }else if ((nindex + 1) % 4 == 0 ){
//        leftOffset = 2;
//        rightOffset = 4;
//    }else{
//        leftOffset = 2;
//        rightOffset = 2;
//    }
//    
//    if (nindex/4 == 0) {
//        topOffset = 4;
//        bottomOffset = 2;
//    }else{
//        topOffset = 2;
//        bottomOffset = 2;
//    }
//    [self.photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.left.equalTo(self.contentView).with.offset(leftOffset);
//        make.right.equalTo(self.contentView).with.offset( - rightOffset);
//        make.top.equalTo(self.contentView).with.offset(topOffset);
//        make.bottom.equalTo(self.contentView).with.offset(- bottomOffset);
//    }];
}
@end
