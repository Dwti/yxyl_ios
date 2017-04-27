//
//  YXAddPhotoTableViewCell.m
//  YanXiuStudentApp
//
//  Created by wd on 15/9/28.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXAddPhotoTableViewCell.h"
#import "YXAddPhotoView.h"
#import "YXPhotoManager.h"
#import "YXPhotoEmptyView.h"
#import "YXPhotoModel.h"


@interface YXAddPhotoTableViewCell ()

@property (nonatomic, assign) BOOL addEnable;
@property (nonatomic, assign) CGFloat addPhotoStartY;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *noAnswerLabel;
@property (nonatomic, strong) UIImageView *typeBGImageView;
@property (nonatomic, strong) UIImageView *answerImageView;
@property (nonatomic, strong) YXPhotoEmptyView *emptyView;
@property (nonatomic, strong) YXAddPhotoView *addPhotoView;
@property (nonatomic, strong) YXAlbumViewModel *viewModel;

@end


@implementation YXAddPhotoTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (NSArray *)getPhotoArray {
    NSMutableArray * array = [NSMutableArray array];
    [self.viewModel.selectPhotoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YXPhotoModel class]]) {
            QAImageAnswer * data = [[QAImageAnswer alloc] init];
            data.data = obj;
            [array addObject:data];
        }
    }];
    return array;
}

- (void)reloadViewWithArray:(NSArray *)array addEnable:(BOOL)enable {
    if (!_viewModel) {
        _viewModel = [[YXAlbumViewModel alloc] init];
    }
    
    NSMutableArray * newArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[QAImageAnswer class]]) {
            QAImageAnswer * data = obj;
            if (data.data) {
                [newArray addObject:data.data];
            }else{
                YXPhotoModel *model = [[YXPhotoModel alloc]initWithURL:[NSURL URLWithString:data.url]];
                model.thumbImageUrl = data.url;
                [newArray addObject:model];
            }
        }
    }];
    _viewModel.selectPhotoArray = newArray;
    _addEnable = enable;
    
    [self setupViews];
    [self setupRAC];
}

- (CGFloat)height {
    if (self.viewModel.selectPhotoArray.count == 0) {
        return 57 + 10;
    }
    return [self.addPhotoView getHight];
}

- (void)setupViews {
    self.answerImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"A"]];
    [self.contentView addSubview:self.answerImageView];
    [self.answerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(26, 28));
    }];
    
    if (!_addPhotoView) {
        _addPhotoView = [[YXAddPhotoView alloc] initWithFrame:CGRectZero addEnable:_addEnable];
        _addPhotoView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:_addPhotoView];
        [_addPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(64);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(100);
        }];
    }
    
    return;
}

- (void)setupRAC {
    @weakify(self);
    [[RACObserve(_viewModel, selectPhotoArray) deliverOnMainThread] subscribeNext:^(NSArray * photosArray) {
        @strongify(self);
        BLOCK_EXEC(self.photosChangedBlock,[self getPhotoArray]);
        
        if (!self.addEnable && (photosArray == nil || [photosArray count] == 0)) {
            self.addPhotoView.hidden = YES;
            [self.emptyView removeFromSuperview];
            self.emptyView = [[YXPhotoEmptyView alloc]init];
            [self.contentView addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(64);
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(photoViewHeightChanged:)]) {
                [self.delegate photoViewHeightChanged:(57 + 10)];
            }
        } else {
            self.addPhotoView.hidden = NO;
            self.noAnswerLabel.hidden = YES;
            [self.addPhotoView reloadWithPhotosArray:photosArray];
            [self.addPhotoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo([self.addPhotoView getHight]);
            }];
            if (self.delegate && [self.delegate respondsToSelector:@selector(photoViewHeightChanged:)]) {
                [self.delegate photoViewHeightChanged:[self.addPhotoView getHight]];
            }
            return;
        }
    }];
    
    self.addPhotoView.photoHandle = ^(NSInteger nInteger) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(photoClickedWithModel:index:canDelete:)]) {
            [self.delegate photoClickedWithModel:self.viewModel index:nInteger canDelete:self.addEnable];
        }
    };
    
    self.addPhotoView.addHandle = ^() {
        @strongify(self);
        if (!self.viewModel.albumListArray || [self.viewModel.albumListArray count] == 0) {
            [self.viewModel gotoGetAlbumListArray];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(addPhotoWithViewModel:)]) {
            [self.delegate addPhotoWithViewModel:self.viewModel];
        }
    };
}

@end
