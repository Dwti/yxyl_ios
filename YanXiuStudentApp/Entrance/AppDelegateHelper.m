//
//  AppDelegateHelper.m
//  AppDelegateTest
//
//  Created by niuzhaowang on 2016/9/26.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "AppDelegateHelper.h"
#import "AppDelegateHelper_Phone.h"
#import "AppDelegateHelper_Pad.h"

@interface AppDelegateHelper ()
@property (nonatomic, strong) UIWindow *window;
@end

@implementation AppDelegateHelper

+ (instancetype)alloc{
    if ([self class] == [AppDelegateHelper class]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            return [AppDelegateHelper_Phone alloc];
        }
        return [AppDelegateHelper_Pad alloc];
    }
    return [super alloc];
}

- (instancetype)initWithWindow:(UIWindow *)window {
    if (self = [super init]) {
        self.window = window;
    }
    return self;
}

- (UIViewController *)rootViewController{
    return nil;
}

- (void)handleLoginSuccess {
    
}

- (void)handleLogoutSuccess {
    
}

- (void)apnsGoHomeworkList:(YXApnsContentModel *)model {
    
}

- (void)apnsGoHomework:(YXApnsContentModel *)model {
    
}

- (void)handleStageChange {
    
}

@end
