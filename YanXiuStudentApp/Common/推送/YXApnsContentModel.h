//
//  YXApnsContentModel.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 10/9/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "JSONModel.h"

@interface YXApnsContentModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *msg_type;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *uid;
@property (nonatomic, copy) NSString<Optional> *msg_title;
@property (nonatomic, copy) NSString<Optional> *payload;

//@property (nonatomic, copy) NSString<Ignore> *groupId;
//
//@property (nonatomic, copy) NSString<Ignore> *paperId;
//@property (nonatomic, copy) NSString<Ignore> *paperTitle;


@end
