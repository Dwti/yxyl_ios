//
//  GetTopicTreeRequest.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetTopicTreeRequestItem_theme <NSObject>
@end
@interface GetTopicTreeRequestItem_theme : JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *themeId;
@property (nonatomic, copy) NSString<Optional> *resource_num;
@property (nonatomic, copy) NSString<Optional> *question_num;
@property (nonatomic, strong) NSArray<GetTopicTreeRequestItem_theme,Optional> *children;
@end

@protocol GetTopicTreeRequestItem <NSObject>
@end
@interface GetTopicTreeRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetTopicTreeRequestItem_theme,Optional> *themes;
@end

@protocol GetTopicTreeRequest <NSObject>
@end
@interface GetTopicTreeRequest : YXGetRequest
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *subjectId;

@end
