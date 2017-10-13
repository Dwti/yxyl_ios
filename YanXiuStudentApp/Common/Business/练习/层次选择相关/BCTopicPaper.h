//
//  BCTopicPaper.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BCTopicPaper_paperStatus : JSONModel
@property (nonatomic, copy) NSString<Optional> *status; //0-未作答 1-作答中 (本地记录)，2-完成 
@property (nonatomic, copy) NSString<Optional> *ppid; //练习试卷id
@property (nonatomic, copy) NSString<Optional> *scoreRate; //正确率
@end

@protocol BCTopicPaper <NSObject>
@end

@interface BCTopicPaper : JSONModel
@property (nonatomic, copy) NSString<Optional> *rmsPaperId;//媒资资源id （rmsPaperId）
@property (nonatomic, copy) NSString<Optional> *viewnum;//预览数
@property (nonatomic, copy) NSString<Optional> *name;//名称
@property (nonatomic, copy) BCTopicPaper_paperStatus<Optional> *paperStatus;//当未作答的时候没有paperStatus的字段返回
@end
