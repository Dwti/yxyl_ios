//
//  QAClassifyOptionCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/5.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAClassifyOptionCell : UICollectionViewCell
@property (nonatomic, strong) NSString *optionString;
@property (nonatomic, assign) BOOL canDelete;
@property (nonatomic, assign) BOOL isCorrect;
@property (nonatomic, strong) void(^deleteBlock) (void);
@property (nonatomic, strong) void(^sizeChangedBlock) (CGSize size);

+ (QAClassifyOptionCell *)cellWithOption:(NSString *)option;

- (CGSize)defaultSize;
@end
