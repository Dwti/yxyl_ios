//
//  YXQAPaperStaticticData.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXQAPaperStaticticData : NSObject
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger answered;
@property (nonatomic, assign) NSInteger corrected;
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, assign) NSInteger subjectiveCount; // 主观题数目
@property (nonatomic, assign) CGFloat subjectiveTotalScore; // 主观题总得分

+ (YXQAPaperStaticticData *)dataFromQAModel:(QAPaperModel *)model;
@end
