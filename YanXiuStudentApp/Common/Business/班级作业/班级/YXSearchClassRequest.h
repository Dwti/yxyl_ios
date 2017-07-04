//
//  YXSearchClassRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"


@interface YXSearchClassItem_Data : JSONModel

@property (nonatomic, copy) NSString<Optional> *gid;            //班级id
@property (nonatomic, copy) NSString<Optional> *name;           //班级名称
@property (nonatomic, copy) NSString<Optional> *authorid;       //创建者id
@property (nonatomic, copy) NSString<Optional> *authorname;     //创建者姓名
//@property (nonatomic, copy) NSString<Optional> *subjectid;    //科目id
//@property (nonatomic, copy) NSString<Optional> *subjectname;  //科目名称
@property (nonatomic, copy) NSString<Optional> *bedition;       //教材版本id
@property (nonatomic, copy) NSString<Optional> *beditionname;   //教材版本名称
@property (nonatomic, copy) NSString<Optional> *stageid;        //学段id
@property (nonatomic, copy) NSString<Optional> *stagename;      //学段名称
@property (nonatomic, copy) NSString<Optional> *gradeid;        //年级id
@property (nonatomic, copy) NSString<Optional> *gradename;      //年级名称
@property (nonatomic, copy) NSString<Optional> *buildtime;      //创建时间
@property (nonatomic, copy) NSString<Optional> *status;         //是否需要审核
@property (nonatomic, copy) NSString<Optional> *stdnum;         //人数
@property (nonatomic, copy) NSString<Optional> *isMemeberFull;  //人员是否已满 0 表示未满， 1表示已满

@property (nonatomic, copy) NSString<Optional> *schoolid;       //学校id
@property (nonatomic, copy) NSString<Optional> *schoolname;     //学校名称
@property (nonatomic, copy) NSString<Optional> *teachernum;     //老师人数
@property (nonatomic, copy) NSString<Optional> *periodid;
@property (nonatomic, copy) NSString<Optional> *adminid;
@property (nonatomic, copy) NSString<Optional> *adminName; //老师姓名

@property (nonatomic, copy) NSString<Optional> *areaid;     
@property (nonatomic, copy) NSString<Optional> *cityid;
@property (nonatomic, copy) NSString<Optional> *provinceid;

@property (nonatomic, copy) NSString<Optional> *mobile;

- (BOOL)needToVerify;
- (BOOL)memberIsFull;
@end

@protocol YXSearchClassItem_Data @end

// code为0是班级存在，2是班级不存在
@interface YXSearchClassItem : HttpBaseRequestItem

@property (nonatomic, copy) NSArray<YXSearchClassItem_Data, Optional> *data;

@end

// 搜索班级信息
@interface YXSearchClassRequest : YXGetRequest

@property (nonatomic, strong) NSString *classId; //班级ID

@end
