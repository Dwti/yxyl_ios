//
//  QASubjectivePhotoCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QASubjectivePhotoCell.h"
#import "QASubjectiveSinglePhotoView.h"
#import "QASubjectiveAddPhotoView.h"
#import "QASubjectivePhotoHandler.h"

static const NSInteger kMaxPhotoCount = 3;

@interface QASubjectivePhotoCell()
@property (nonatomic, strong) NSMutableArray<QAImageAnswer *> *photoArray;
@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic, strong) NSMutableArray<QASubjectiveSinglePhotoView *> *photoViewArray;
@property (nonatomic, strong) QASubjectivePhotoHandler *photoHandler;
@end

@implementation QASubjectivePhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.photoViewArray = [NSMutableArray array];
        self.photoHandler = [[QASubjectivePhotoHandler alloc]init];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
}

- (void)updateWithPhotos:(NSMutableArray *)photos editable:(BOOL)isEditable {
    self.photoArray = photos;
    self.isEditable = isEditable;
    
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (photos.count == 0) {
        if (self.isEditable) {
            [self setupAddPhotoView];
        }else {
            [self setupEmptyView];
        }
    }else {
        [self setupPhotosView];
    }
}

- (void)setupAddPhotoView {
    UIButton *addPhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 250, 50)];
    addPhotoButton.center = CGPointMake(SCREEN_WIDTH/2, 50);
    [addPhotoButton setTitle:@"开始作答" forState:UIControlStateNormal];
    [addPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addPhotoButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateNormal];
    addPhotoButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    addPhotoButton.layer.cornerRadius = 6;
    addPhotoButton.clipsToBounds = YES;
    [addPhotoButton addTarget:self action:@selector(addPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addPhotoButton];
}

- (void)addPhotoAction {
    [self goAddPhoto];
}

- (void)setupEmptyView {
    UILabel *emptyLabel = [[UILabel alloc]init];
    emptyLabel.text = @"本题未作答";
    emptyLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
    emptyLabel.font = [UIFont boldSystemFontOfSize:17];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:emptyLabel];
    [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (void)setupPhotosView {
    NSMutableArray *viewArray = [NSMutableArray array];
    __block CGFloat x = 15-8;
    [self.photoArray enumerateObjectsUsingBlock:^(QAImageAnswer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QASubjectiveSinglePhotoView *photoView = [self photoViewForImageAnswer:obj];
        if (photoView) {
            photoView.frame = CGRectMake(x, 15-8, 70+16, 70+16);
        }else {
            photoView = [[QASubjectiveSinglePhotoView alloc]initWithFrame:CGRectMake(x, 15-8, 70+16, 70+16)];
        }
        photoView.canDelete = self.isEditable;
        photoView.imageAnswer = obj;
        photoView.showImageBorder = !self.isEditable;
        WEAK_SELF
        [photoView setClickBlock:^{
            STRONG_SELF
            [self goBrowsePhotosWithIndex:idx];
        }];
        [photoView setDeleteBlock:^{
            STRONG_SELF
            [self.photoArray removeObject:obj];
            [self updateWithPhotos:self.photoArray editable:self.isEditable];
            BLOCK_EXEC(self.numberChangedBlock,self.photoArray.count+1,self.photoArray.count);
        }];
        [self.contentView addSubview:photoView];
        [viewArray addObject:photoView];
        x = x+16+70;
    }];
    self.photoViewArray = viewArray;
    
    if (self.isEditable && self.photoArray.count<kMaxPhotoCount) {
        QASubjectiveAddPhotoView *view = [[QASubjectiveAddPhotoView alloc]initWithFrame:CGRectMake(x+8, 15, 70, 70)];
        WEAK_SELF
        [view setAddAction:^{
            STRONG_SELF
            [self goAddPhoto];
        }];
        [self.contentView addSubview:view];
    }
}

- (QASubjectiveSinglePhotoView *)photoViewForImageAnswer:(QAImageAnswer *)answer {
    for (QASubjectiveSinglePhotoView *view in self.photoViewArray) {
        if (view.imageAnswer == answer) {
            return view;
        }
    }
    return nil;
}

#pragma mark - Photo handle
- (void)goAddPhoto {
    WEAK_SELF
    [self.photoHandler addPhotoWithCompleteBlock:^(UIImage *image) {
        STRONG_SELF
        QAImageAnswer *answer = [[QAImageAnswer alloc]init];
        answer.data = image;
        [self.photoArray addObject:answer];
        [self updateWithPhotos:self.photoArray editable:self.isEditable];
        BLOCK_EXEC(self.numberChangedBlock,self.photoArray.count-1,self.photoArray.count);
    }];
}

- (void)goBrowsePhotosWithIndex:(NSInteger)index {
    WEAK_SELF
    [self.photoHandler browsePhotos:self.photoArray oriIndex:index editable:self.isEditable deleteBlock:^{
        STRONG_SELF
        [self updateWithPhotos:self.photoArray editable:self.isEditable];
        BLOCK_EXEC(self.numberChangedBlock,self.photoArray.count+1,self.photoArray.count);
    }];
}

@end
