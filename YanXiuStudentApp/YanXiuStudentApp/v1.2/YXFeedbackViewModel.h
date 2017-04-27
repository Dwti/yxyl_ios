//
//  YXFeedbackViewModel.h
//  YanXiuStudentApp
//
//  Created by wd on 15/11/3.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXViewModel.h"

@interface YXFeedbackViewModel : YXViewModel

@property (nonatomic, strong) NSString  *content;
@property (nonatomic, strong) RACCommand    *feedbackCommand;

@end
