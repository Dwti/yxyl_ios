//
//  YXCrypt.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 8/20/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXCrypt.h"

@implementation YXCrypt
+ (NSString *)decryptForString:(NSString *)org {
    NSString *pwd = @"ws3edaw4";
    NSData *d1 = [MF_Base64Codec dataFromBase64String:org];
    CCCryptorStatus status = kCCSuccess;
    NSData * d2 = [d1 decryptedDataUsingAlgorithm: kCCAlgorithmDES
                                                    key: pwd
                                                options: (kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                  error: &status];
    
    if (status != kCCSuccess) {
        NSLog(@"decrypt error");
    }
    
    NSString *des = [[NSString alloc] initWithData:d2 encoding:NSUTF8StringEncoding];
    return des;
}

@end
