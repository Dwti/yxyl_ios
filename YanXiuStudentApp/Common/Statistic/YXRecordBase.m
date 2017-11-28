//
//  YXRecordBase.m
//  StatisticDemo
//
//  Created by niuzhaowang on 16/5/31.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXRecordBase.h"
#import "YXUserManager.h"

@interface YXRecordBase()

@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *clientType;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *appkey;
@property (nonatomic, copy) NSString *url;

@end

@implementation YXRecordBase

#pragma mark- Get
+ (NSString *)timestamp
{
    NSDate          *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a     = [dat timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%.0f", a];
}

#pragma mark- Set
- (void)setType:(YXRecordType)type
{
    _type = type;
    self.eventID = [NSString stringWithFormat:@"20:event_%d", (int)type];
}

#pragma mark-
- (instancetype)init{
    if (self = [super init]) {
        self.strategy      = YXRecordStrategyInstant;
        self.shouldKeepLog = YES;
        self.timestamp     = [self.class timestamp];
        self.clientType    = @"0";
        self.source        = @"0";
        self.uid           = [YXUserManager sharedManager].userModel.uid;
        self.ip            = @"";
        self.url           = @"";
        self.resID         = @"";
        self.appkey        = @"20001";
    }
    return self;
}

- (NSString *)toJSONString{
    NSData* jsonData = nil;
    NSError* jsonError = nil;
    
    @try {
        NSDictionary* dict = [self toDictionary];
        jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&jsonError];
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

- (NSDictionary *)toDictionary{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:[super toDictionary]];
    [mDic setValue:nil forKey:@"strategy"];
    [mDic setValue:nil forKey:@"shouldKeepLog"];
    [mDic setValue:nil forKey:@"type"];
    return [NSDictionary dictionaryWithDictionary:mDic];
}

@end
