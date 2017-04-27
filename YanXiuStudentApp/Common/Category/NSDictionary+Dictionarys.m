
//
//  NSDictionary+Dictionarys.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "NSDictionary+Dictionarys.h"

@implementation NSDictionary (Dictionarys)

- (NSString *)JsonString{
    
    NSData* jsonData = nil;
    NSError* jsonError = nil;
    
    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&jsonError];
    }
    @catch (NSException *exception) {
        //this should not happen in properly design JSONModel
        //usually means there was no reverse transformer for a custom property
        JMLog(@"EXCEPTION: %@", exception.description);
        return nil;
    }
    
    return [[NSString alloc] initWithData: jsonData
                                 encoding: NSUTF8StringEncoding];
}

@end
