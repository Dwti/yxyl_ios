//
//  YXMockPageRequest.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/9/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXMockPageRequest.h"
@implementation YXMockPageRequestItem
@end

@implementation YXMockPageRequest

- (void)startRequestWithRetClass:(Class)retClass
                andCompleteBlock:(HttpRequestCompleteBlock)completeBlock
{
    _completeBlock = completeBlock;
    double rd = [self randStart:1 end:100];
    if (rd < 20) {
        // 20% 失败
        DDLogError(@"generate mock error");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSError *error = [NSError errorWithDomain:@"mock" code:0 userInfo:nil];
            self->_completeBlock(nil, error);
        });
        return;
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            self->_completeBlock([self generateMockForPage:self.pageindex], nil);
            
        });
        return;
    }
}

- (int)randStart:(int)a end:(int)b {
    int fromNumber = a;
    int toNumber = b + 1;
    int randomNumber = (arc4random()%(toNumber-fromNumber))+fromNumber;
    return randomNumber;
}

- (YXMockPageRequestItem *)generateMockForPage:(NSInteger)index {
    YXMockPageRequestItem *ret = [[YXMockPageRequestItem alloc] init];
    
    NSInteger totalpage = (self.mockTotal + self.pagesize - 1) / self.pagesize;
    if (index >= totalpage) {
        ret.total = self.mockTotal;
        ret.dataArray = nil;
        return ret;
    }
    
    NSInteger size = self.pagesize;
    if ((index == (totalpage - 1)) && (self.mockTotal % self.pagesize)) {
        size = self.mockTotal % self.pagesize;
    }
    
    ret.total = self.mockTotal;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:size];
    for (int i = 0; i < size; i++) {
        [arr addObject:@(i + index * self.pagesize)];
    }
    ret.dataArray = [NSArray arrayWithArray:arr];
    return ret;
}

@end
