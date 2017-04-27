//
//  YXQAAddPhotoCell_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAAddPhotoCell_Pad.h"
#import "YXAddPhotoView.h"
#import "YXPhotoEmptyView.h"

@interface YXQAAddPhotoCell_Pad()
@property (nonatomic, strong) UIImageView *answerImageView;

@property(nonatomic, strong)YXAddPhotoView * addPhotoView;
@property(nonatomic, assign)BOOL             addEnable;
@property(nonatomic, strong)UIView *         lineView;
@property(nonatomic, strong)UILabel *        noAnswerLabel;
@property(nonatomic, strong)UIImageView*     typeBGImageView;
@property(nonatomic, assign)CGFloat          addPhotoStartY;
@property(nonatomic, strong)YXPhotoEmptyView *emptyView;
@end

@implementation YXQAAddPhotoCell_Pad


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSArray *)getPhotoArray
{
    NSMutableArray * array = [NSMutableArray array];
    [self.viewModel.selectPhotoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YXPhotoModel class]]) {
            QAImageAnswer *answer = [[QAImageAnswer alloc]init];
            answer.data = obj;
            [array addObject:answer];
        }
    }];
    return array;
}
- (void)reloadViewWithArray:(NSArray *)array addEnable:(BOOL)enable
{
    if (!_viewModel) {
        _viewModel = [[YXAlbumViewModel alloc] init];
    }
    NSMutableArray * newArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[QAImageAnswer class]]) {
            QAImageAnswer *answer = obj;
            if (answer.data) {
                [newArray addObject:answer.data];
            }else{
                YXPhotoModel *model = [[YXPhotoModel alloc]initWithURL:[NSURL URLWithString:answer.url]];
                model.thumbImageUrl = answer.url;
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

- (void)setupViews
{
    self.answerImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"A"]];
    [self.contentView addSubview:self.answerImageView];
    [self.answerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(39);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(26, 28));
    }];
    
    if (!_addPhotoView) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 360 - 11 - 80 - 40;
        _addPhotoView = [[YXAddPhotoView alloc]initWithFrame:CGRectZero photoNumberPerRow:8 maxWidth:width addEnable:_addEnable];
        _addPhotoView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:_addPhotoView];
        [_addPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(80);
            make.right.mas_equalTo(-40);
            make.height.mas_equalTo(100);
        }];
    }
    
    // TBD : 有了解析的图和标注后，这里需要添加？
    return;
    
    
}


- (void)setupRAC
{
    @weakify(self);
    [[RACObserve(_viewModel, selectPhotoArray) deliverOnMainThread] subscribeNext:^(NSArray * photosArray) {
        @strongify(self);
        if (!self.addEnable && (photosArray == nil || [photosArray count] == 0)) {
            self.addPhotoView.hidden = YES;
            [self.emptyView removeFromSuperview];
            self.emptyView = [[YXPhotoEmptyView alloc]init];
            [self.contentView addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(80);
                make.right.mas_equalTo(-40);
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(photoViewHeightChanged:)]) {
                [self.delegate photoViewHeightChanged:57 + 10];
            }
        }else{
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
    self.addPhotoView.photoHandle = ^(NSInteger nInteger){
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(photoClickedWithModel:index:canDelete:)]) {
            [self.delegate photoClickedWithModel:self.viewModel index:nInteger canDelete:self.addEnable];
        }
    };
    self.addPhotoView.addHandle = ^(){
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
