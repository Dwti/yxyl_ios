//
//  PagedListFetcherBase.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/21/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "PagedListFetcherBase.h"


@interface PagedListFetcherBase ()
@property (nonatomic, assign) NSInteger pre_pageindex;
@property (nonatomic, assign) NSInteger pre_lastID;
@end

@implementation PagedListFetcherBase

- (instancetype)init {
    if (self = [super init]) {
        self.pagesize = 10;
        self.pageindex = 0;
        self.lastID = 0;
    }
    return self;
}

- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    _completeBlock = aCompleteBlock;
}

- (void)stop {
    
}

- (NSArray *)cachedItemArray {
    return nil;
}

- (int)cachedTotalNumber {
    return INT16_MAX;   // default to always allow load more even in cache mode
}

- (void)saveToCache {
    
}

#pragma mark - PageListRequestDelegate
- (void)requestWillRefresh {
    self.pre_pageindex = self.pageindex;
    self.pre_lastID = self.lastID;
    self.pageindex = 0;
    self.lastID = 0;
}

- (void)requestEndRefreshWithError:(NSError *)error {
    if (error) {
        self.pageindex = self.pre_pageindex;
        self.lastID = self.pre_lastID;
    }else {
        self.pageindex++;
    }
}

- (void)requestWillFetchMore {

}

- (void)requestEndFetchMoreWithError:(NSError *)error {
    if (!error) {
        self.pageindex++;
    }
}

@end
