//
//  YXRedNumberRequest.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/4/7.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"


@interface YXNumberItem : JSONModel

@property (nonatomic, copy) NSString <Optional> *paperNum;

@end

@interface YXRedNumberItem : HttpBaseRequestItem

@property (nonatomic, copy) YXNumberItem <Optional> *property;

@end

@interface YXRedNumberRequest : YXGetRequest

@end
