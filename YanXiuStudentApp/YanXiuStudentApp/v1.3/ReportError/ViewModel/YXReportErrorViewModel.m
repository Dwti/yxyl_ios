//
//  YXReportErrorViewModel.m
//  YanXiuStudentApp
//
//  Created by wd on 15/11/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXReportErrorViewModel.h"
#import "YXQAErrorReportRequest.h"

@interface YXReportErrorViewModel ()

@property (nonatomic, strong) YXQAErrorReportRequest  *reportErrorRequest;

@end

@implementation YXReportErrorViewModel

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"题目报错";
        _reportErrorRequest = [[YXQAErrorReportRequest alloc] init];
        [self setupCommands];
    }
    return self;
}

- (void)setupCommands
{
    @weakify(self);
    _reportErrorCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if (self.reportErrorRequest) {
            [self.reportErrorRequest stopRequest];
        }
        self.reportErrorRequest = [[YXQAErrorReportRequest alloc] init];
        self.reportErrorRequest.content = self.content;
        self.reportErrorRequest.uid = [YXUserManager sharedManager].userModel.uid;
        self.reportErrorRequest.quesId = self.quesId;
        
        RACSignal * signal = [RACSignal empty];
        signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [self.reportErrorRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
                if (!error) {
                    [subscriber sendNext:@YES];
                    [subscriber sendCompleted];
                    
                } else {
                    [subscriber sendError:error];
                }
            }];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
        signal = [signal flattenMap:^RACStream *(id value) {
            if ([value isKindOfClass:[NSError class]]) {
                return [RACSignal error: value];
            }else{
                return [RACSignal return:value];
            }
        }];
        [signal catch:^RACSignal *(NSError *error) {
            return [RACSignal error: error];
        }];
        return signal;
    }];
}

@end
