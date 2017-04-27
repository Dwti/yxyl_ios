//
//  PageListRequestDelegate.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 4/1/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PageListRequestDelegate <NSObject>
- (void)requestWillRefresh;
- (void)requestEndRefreshWithError:(NSError *)error;
- (void)requestWillFetchMore;
- (void)requestEndFetchMoreWithError:(NSError *)error;
@end
