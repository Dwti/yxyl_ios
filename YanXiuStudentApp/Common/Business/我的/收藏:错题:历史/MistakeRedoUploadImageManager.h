//
//  MistakeRedoUploadImageManager.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/7/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MistakeRedoUploadImageManager : NSObject
+ (instancetype)sharedInstance;
- (void)uploadImageInQuestion:(QAQuestion *)question completeBlock:(void (^) (NSError *error))completeBlock;
- (void)stopUploadImage;
@end
