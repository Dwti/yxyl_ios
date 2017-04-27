//
//  YXDelMistakeRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/15.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

// 删除错题
@interface YXDelMistakeRequest : YXGetRequest

@property (nonatomic, strong) NSString *questionId; //要删除的错题Id

@end
