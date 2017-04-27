//
//  LaunchAppItem.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/19/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "LaunchAppItem.h"

@implementation LaunchAppItem

+ (NSString *)networkStatus {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    if (status == ReachableViaWiFi) {
        return @"0";
        
    } else if (status == ReachableViaWWAN) {
        
        NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                                   CTRadioAccessTechnologyGPRS,
                                   CTRadioAccessTechnologyCDMA1x];
        
        NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                                   CTRadioAccessTechnologyWCDMA,
                                   CTRadioAccessTechnologyHSUPA,
                                   CTRadioAccessTechnologyCDMAEVDORev0,
                                   CTRadioAccessTechnologyCDMAEVDORevA,
                                   CTRadioAccessTechnologyCDMAEVDORevB,
                                   CTRadioAccessTechnologyeHRPD];
        
        NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
        
        CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
        NSString *accessString = teleInfo.currentRadioAccessTechnology;
        
        if ([typeStrings4G containsObject:accessString]) {
            return @"2"; //4G网络
        } else if ([typeStrings3G containsObject:accessString]) {
            return @"3"; //3G网络
        } else if ([typeStrings2G containsObject:accessString]) {
            return @"4"; //2G网络
        } else {
            return @"5"; //未知网络
        }
    } else {
        return @"5";
    }
}

+ (NSString *)screenResolution {
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGRect screen = [[UIScreen mainScreen] bounds];
    NSInteger widthInPixel = screen.size.width * scaleFactor;
    NSInteger heightInPixel = screen.size.height * scaleFactor;
    
    return [NSString stringWithFormat:@"%ld * %ld", (long)heightInPixel, (long)widthInPixel];
}


@end
