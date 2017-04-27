//
//  YXQAUploadImageManager.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/18.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAUploadImageManager.h"
#import "YXUploadImageRequest.h"
#import "MWPhoto.h"

@interface YXQAUploadImageManager()
@property (nonatomic, assign) NSInteger checkedCount;
@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, copy) void(^completeBlock)(NSError *error);
@property (nonatomic, strong) YXUploadImageRequest *uploadImageRequest;
@property (nonatomic, strong) NSArray *questionArray;

@property (nonatomic, copy) UploadImageProgressBlock progressBlock;
@end

@implementation YXQAUploadImageManager

+ (instancetype)sharedInstance
{
    static YXQAUploadImageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YXQAUploadImageManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark -
- (void)stopUploadImage{
    [self.uploadImageRequest stopRequest];
}

- (void)uploadImageInModel:(QAPaperModel *)model completeBlock:(void(^)(NSError *error))completeBlock{
    self.checkedCount = 0;
    self.model = model;
    self.questionArray = [self needUploadImageQuestionsInModel:model];
    self.completeBlock = completeBlock;
    
    BLOCK_EXEC(self.progressBlock,self.checkedCount,self.questionArray.count);
    
    [self checkAndStart];
}

- (NSMutableArray *)needUploadImageQuestionsInModel:(QAPaperModel *)model {
    NSMutableArray *array = [NSMutableArray array];
    NSArray *allQuestions = [model allQuestions];
    for (QAQuestion *question in allQuestions) {
        if (question.templateType == YXQATemplateSubjective) {
            [question.myAnswers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                QAImageAnswer *answer = obj;
                if (isEmpty(answer.url)) {
                    [array addObject:question];
                    *stop = YES;
                }
            }];
        }
    }
    return array;
}

- (void)checkAndStart{
    QAQuestion *item = [self nextUploadItem];
    if (!item) {
        self.completeBlock(nil);
    }else{
        [self uploadImageinItem:item];
    }
}

- (void)uploadImageinItem:(QAQuestion *)item{
    self.uploadImageRequest = [[YXUploadImageRequest alloc]init];
    [item.myAnswers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAImageAnswer *answer = (QAImageAnswer *)obj;
        if (isEmpty(answer.url)) {
            MWPhoto *photo = (MWPhoto *)answer.data;
            [photo loadUnderlyingImageAndNotify];
            UIImage *image = [photo underlyingImage];
            UIImage *compressedImage = [self compressedImageWithImage:image];
            NSData *jpgData = UIImageJPEGRepresentation(compressedImage, 1);
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",@(idx)];
            NSString *key = [NSString stringWithFormat:@"%@",@(idx)];
            [self.uploadImageRequest.request addData:jpgData withFileName:fileName andContentType:nil forKey:key];
        }
    }];
    self.uploadImageRequest.request.timeOutSeconds = 6000;
    @weakify(self);
    [self.uploadImageRequest startRequestWithRetClass:[YXUploadImageRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        if (!self) {
            return;
        }
        if (error) {
            self.completeBlock(error);
            return;
        }
        YXUploadImageRequestItem *requestRetItem = (YXUploadImageRequestItem *)retItem;
        __block NSInteger seekIndex = 0;
        [requestRetItem.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (; seekIndex<item.myAnswers.count; seekIndex++) {
                QAImageAnswer *answer = item.myAnswers[seekIndex];
                if (isEmpty(answer.url)) {
                    answer.url = obj;
                    break;
                }
            }
        }];
        
        self.checkedCount++;
        BLOCK_EXEC(self.progressBlock,self.checkedCount,self.questionArray.count);
        [self checkAndStart];
    }];
}

- (QAQuestion *)nextUploadItem{
    if (self.checkedCount < self.questionArray.count) {
        return self.questionArray[self.checkedCount];
    }
    return nil;
}

- (UIImage *)compressedImageWithImage:(UIImage *)image{
    return image;
//    CGSize size = image.size;
//    CGSize compressedSize = CGSizeMake(size.width/2, size.height/2);
//    UIGraphicsBeginImageContext(compressedSize);
//    [image drawInRect:CGRectMake(0, 0, compressedSize.width, compressedSize.height)];
//    UIImage *compressedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return compressedImage;
}

#pragma mark - 上传进度部分
- (void)setUploadImageBlock:(UploadImageProgressBlock)block {
    self.progressBlock = block;
}


@end
