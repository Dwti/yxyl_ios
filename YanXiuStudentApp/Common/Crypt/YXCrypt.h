//
//  YXCrypt.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 8/20/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MF_Base64Additions.h>
#import <NSData+CommonCrypto.h>

@interface YXCrypt : NSObject
+ (NSString *)decryptForString:(NSString *)org;
@end
