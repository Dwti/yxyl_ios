//
//  PagedListFetcherBase.h
//  YanXiuApp
//
//  Created by Lei Cai on 5/21/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageListRequestDelegate.h"

@interface PagedListFetcherBase : NSObject<PageListRequestDelegate> {
    void(^_completeBlock)(int total, NSArray *retItemArray, NSError *error);
}

@property (nonatomic, assign) NSInteger lastID;
@property (nonatomic, assign) NSInteger pageindex;
@property (nonatomic, assign) NSInteger pagesize;
@property (nonatomic, assign) BOOL isDataArrayMerged;

- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock;
- (void)stop;
- (NSArray *)cachedItemArray;
- (void)saveToCache;
@end
