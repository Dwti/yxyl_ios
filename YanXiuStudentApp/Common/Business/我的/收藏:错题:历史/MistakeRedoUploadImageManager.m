//
//  MistakeRedoUploadImageManager.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/7/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeRedoUploadImageManager.h"
#import "YXUploadImageRequest.h"
#import "MWPhoto.h"

@interface MistakeRedoUploadImageManager()
@property (nonatomic, strong) QAQuestion *question;
@property (nonatomic, strong) YXUploadImageRequest *uploadImageRequest;
@property (nonatomic, copy) void(^completeBlock)(NSError *error);
@end

@implementation MistakeRedoUploadImageManager

+ (instancetype)sharedInstance {
    static MistakeRedoUploadImageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MistakeRedoUploadImageManager alloc] init];
    });
    return sharedInstance;
}

- (void)uploadImageInQuestion:(QAQuestion *)question completeBlock:(void (^) (NSError *error))completeBlock {
    self.question = question;
    self.completeBlock = completeBlock;
    [self uploadImageInArray:self.question.noteImages];
}

- (void)stopUploadImage {
    [self.uploadImageRequest stopRequest];
}

- (void)uploadImageInArray:(NSArray *)imgAnswerArray {
    if (isEmpty(self.question.noteImages)) {
        return self.completeBlock(nil);
    }
    __block BOOL needUpload = NO;
    self.uploadImageRequest = [[YXUploadImageRequest alloc] init];
    [imgAnswerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAImageAnswer *answer = obj;
        if (isEmpty(answer.url)) {
            UIImage *image = answer.data;
            UIImage *compressedImage = [self compressedImageWithImage:image];
            NSData *jpgData = UIImageJPEGRepresentation(compressedImage, 1);
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",@(idx)];
            NSString *key = [NSString stringWithFormat:@"%@",@(idx)];
            [self.uploadImageRequest.request addData:jpgData withFileName:fileName andContentType:nil forKey:key];
            needUpload = YES;
        }
    }];
    if (!needUpload) {
        BLOCK_EXEC(self.completeBlock,nil);
        return;
    }
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
            for (; seekIndex<imgAnswerArray.count; seekIndex++) {
                QAImageAnswer *answer = imgAnswerArray[seekIndex];
                if (isEmpty(answer.url)) {
                    answer.url = obj;
                    break;
                }
            }
        }];
        
        self.completeBlock(nil);
    }];
}

- (UIImage *)compressedImageWithImage:(UIImage *)image{
    return image;
}

@end
