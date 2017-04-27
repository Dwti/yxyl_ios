//
//  YXGeTuiManager.h
//  YanXiuStudentApp
//
//  Created by FanYu on 9/28/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeTuiSdk.h"
#import "YXApnsContentModel.h"

@protocol YXApnsDelegate <NSObject>
- (void)apnsHomeworkList:(YXApnsContentModel *)apns;    // 某学科作业列表
- (void)apnsHomework:(YXApnsContentModel *)apns;        // 作业Tab首页
@end

@interface YXGeTuiManager : NSObject <GeTuiSdkDelegate>

@property (nonatomic, weak) id<YXApnsDelegate> delegate;

+ (YXGeTuiManager *)sharedInstance;

- (void)loginSuccess;
- (void)logoutSuccess;
- (void)handleApnsContent:(NSDictionary *)dict;
- (void)registerGeTuiWithDelegate:(id)delegate;
- (void)registerDeviceToken:(NSData *)deviceToken;

@end
