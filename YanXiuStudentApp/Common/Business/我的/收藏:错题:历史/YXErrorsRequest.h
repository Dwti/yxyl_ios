//
//  YXErrorsRequest.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/17.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@interface YXErrorsRequest : YXGetRequest

@property (nonatomic, strong) NSString *currentPage; //当前页码
@property (nonatomic, strong) NSString *pageSize; //每页记录条数
@property (nonatomic, strong) NSString *ptype; //请求类型，2按时间排序倒序（默认）
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, copy) NSString *currentId;

@end

@interface YXErrorModel : JSONModel



@end