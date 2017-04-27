//
//  YXFeedbackViewModel.m
//  YanXiuStudentApp
//
//  Created by wd on 15/11/3.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXFeedbackViewModel.h"
#import "YXFeedbackRequest.h"

@interface YXFeedbackViewModel ()

@property (nonatomic, strong) YXFeedbackRequest *feedbackRequest;

@end

@implementation YXFeedbackViewModel

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"意见反馈";
        _feedbackRequest = [[YXFeedbackRequest alloc] init];
        [self setupCommands];
    }
    return self;
}

- (void)setupCommands
{
    @weakify(self);
    _feedbackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if (self.feedbackRequest) {
            [self.feedbackRequest stopRequest];
        }
        self.feedbackRequest = [[YXFeedbackRequest alloc] init];
        self.feedbackRequest.content = self.content;
        RACSignal * signal = [RACSignal empty];
        signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [self.feedbackRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
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
