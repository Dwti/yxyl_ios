//
//  YXRankModel.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/9/22.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXRankRequest.h"

@interface YXRankModel : NSObject
@property (nonatomic, strong) NSString *myRank;
@property (nonatomic, strong) NSArray *rankItemArray;

+ (YXRankModel *)rankModelFromRankRequestItem:(YXRankRequestItem *)requestItem;
@end

@interface YXRankItem : NSObject
@property (nonatomic, strong) NSString *rankNumber;
@property (nonatomic, strong) NSString *portraitUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *answeredNumber;
@property (nonatomic, strong) NSString *correctRate;
@end