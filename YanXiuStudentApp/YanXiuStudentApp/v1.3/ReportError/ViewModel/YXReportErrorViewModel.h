//
//  YXReportErrorViewModel.h
//  YanXiuStudentApp
//
//  Created by wd on 15/11/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXViewModel.h"

@interface YXReportErrorViewModel : YXViewModel

@property (nonatomic, strong) NSString  *content;
@property (nonatomic, strong) NSString  *quesId;
@property (nonatomic, strong) RACCommand    *reportErrorCommand;

@end
