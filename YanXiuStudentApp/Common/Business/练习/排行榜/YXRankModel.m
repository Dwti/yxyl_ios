//
//  YXRankModel.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/9/22.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXRankModel.h"

@implementation YXRankItem

@end

@implementation YXRankModel

+ (YXRankModel *)rankModelFromRankRequestItem:(YXRankRequestItem *)requestItem{
    YXRankModel *model = [[YXRankModel alloc]init];
    model.myRank = requestItem.property.myRank;
    NSMutableArray *array = [NSMutableArray array];
    [requestItem.data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        YXRankRequestItem_data *data = (YXRankRequestItem_data *)obj;
        YXRankItem *item = [[YXRankItem alloc]init];
        item.rankNumber = [NSString stringWithFormat:@"%@",@(idx+1)];
        item.portraitUrl = data.headImg;
        item.name = data.nickName;
        item.school = data.schoolName;
        item.answeredNumber = data.answerquenum;
        item.correctRate = [NSString stringWithFormat:@"%.0f%@",data.correctrate.floatValue*100,@"%"];
        [array addObject:item];
    }];
    model.rankItemArray = array;
    return model;
}

@end
