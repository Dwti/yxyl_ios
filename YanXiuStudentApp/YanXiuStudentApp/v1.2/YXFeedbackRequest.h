//
//  YXFeedbackRequest.h
//  YanXiuStudentApp
//
//  Created by wd on 15/11/9.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface YXFeedbackRequest : YXPostRequest

@property (nonatomic, strong) NSString  *content;   //意见反馈内容
@property (nonatomic, strong) NSString  *os; //设备操作系统
@property (nonatomic, strong) NSString  *osversion; //操作系统版本
//@property (nonatomic, strong) NSString  *version; //app版本号
@property (nonatomic, strong) NSString  *brand; //手机品牌

@property (nonatomic, strong) NSString<Optional> *role;
@end
