//
//  YXRankRequest.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/9/23.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@interface YXRankRequestItem_property : JSONModel
@property (nonatomic, copy) NSString<Optional> *myRank;
@end

@protocol YXRankRequestItem_data <NSObject>
@end
@interface YXRankRequestItem_data : JSONModel
@property (nonatomic, copy) NSString<Optional> *userid;
@property (nonatomic, copy) NSString<Optional> *answerquenum;
@property (nonatomic, copy) NSString<Optional> *correctquenum;
@property (nonatomic, copy) NSString<Optional> *correctrate;
@property (nonatomic, copy) NSString<Optional> *nickName;
@property (nonatomic, copy) NSString<Optional> *schoolName;
@property (nonatomic, copy) NSString<Optional> *headImg;
@end

@interface YXRankRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXRankRequestItem_property<Optional> *property;
@property (nonatomic, strong) NSArray<YXRankRequestItem_data,Optional> *data;
@end

@interface YXRankRequest : YXGetRequest

@end
