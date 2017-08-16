//
//  QANoteImagesView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QANoteImagesView.h"
#import "QASubjectiveSinglePhotoView.h"
#import "QASubjectiveAddPhotoView.h"
#import "QASubjectivePhotoHandler.h"

static const NSInteger kMaxPhotoCount = 4;

@interface QANoteImagesView()
@property (nonatomic, strong) NSMutableArray<QAImageAnswer *> *photoArray;
@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic, strong) NSMutableArray<QASubjectiveSinglePhotoView *> *photoViewArray;
@property (nonatomic, strong) QASubjectivePhotoHandler *photoHandler;
@property (nonatomic, assign) CGFloat photoViewWidth;
@end

@implementation QANoteImagesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.photoViewArray = [NSMutableArray array];
        self.photoHandler = [[QASubjectivePhotoHandler alloc]init];
        self.photoViewWidth = MIN((SCREEN_WIDTH-15*(kMaxPhotoCount+1))/kMaxPhotoCount, 75)+8;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
}

- (void)updateWithPhotos:(NSMutableArray<QAImageAnswer *> *)photos editable:(BOOL)isEditable {
    self.photoArray = photos;
    self.isEditable = isEditable;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self setupPhotosView];
    
//    if (photos.count == 0) {
//        if (self.isEditable) {
//            [self setupAddPhotoView];
//        }else {
//            [self setupEmptyView];
//        }
//    }else {
//        [self setupPhotosView];
//    }
}

- (void)setupAddPhotoView {
    UIButton *addPhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 250, 50)];
    addPhotoButton.center = CGPointMake(SCREEN_WIDTH/2, 52.5);
    [addPhotoButton setTitle:@"添加笔记" forState:UIControlStateNormal];
    [addPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addPhotoButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateNormal];
    addPhotoButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    addPhotoButton.layer.cornerRadius = 6;
    addPhotoButton.clipsToBounds = YES;
    [addPhotoButton addTarget:self action:@selector(addPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addPhotoButton];
}

- (void)addPhotoAction {
    [self goAddPhoto];
}

- (void)setupEmptyView {
    
}

- (void)setupPhotosView {
    NSMutableArray *viewArray = [NSMutableArray array];
    __block CGFloat x = 15;
    [self.photoArray enumerateObjectsUsingBlock:^(QAImageAnswer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QASubjectiveSinglePhotoView *photoView = [self photoViewForImageAnswer:obj];
        if (photoView) {
            photoView.frame = CGRectMake(x, 15-8, self.photoViewWidth, self.photoViewWidth);
        }else {
            photoView = [[QASubjectiveSinglePhotoView alloc]initWithFrame:CGRectMake(x, 15-8, self.photoViewWidth, self.photoViewWidth)];
        }
        photoView.showImageBorder = NO;
        photoView.canDelete = self.isEditable;
        photoView.imageAnswer = obj;
        WEAK_SELF
        [photoView setClickBlock:^{
            STRONG_SELF
            [self goBrowsePhotosWithIndex:idx];
        }];
        [photoView setDeleteBlock:^{
            STRONG_SELF
            [self.photoArray removeObject:obj];
            [self updateWithPhotos:self.photoArray editable:self.isEditable];
        }];
        [self addSubview:photoView];
        [viewArray addObject:photoView];
        x = x+self.photoViewWidth+7;
    }];
    self.photoViewArray = viewArray;
    
    if (self.isEditable && self.photoArray.count<kMaxPhotoCount) {
        QASubjectiveAddPhotoView *view = [[QASubjectiveAddPhotoView alloc]initWithFrame:CGRectMake(x, 15, self.photoViewWidth-8, self.photoViewWidth-8)];
        WEAK_SELF
        [view setAddAction:^{
            STRONG_SELF
            [self goAddPhoto];
        }];
        [self addSubview:view];
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
    }];
}

- (void)goBrowsePhotosWithIndex:(NSInteger)index {
    WEAK_SELF
    [self.photoHandler browsePhotos:self.photoArray oriIndex:index editable:self.isEditable deleteBlock:^{
        STRONG_SELF
        [self updateWithPhotos:self.photoArray editable:self.isEditable];
    }];
}

@end
