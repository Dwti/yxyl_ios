//
//  YXMockRequest.m
//  StatisticDemo
//
//  Created by niuzhaowang on 16/5/31.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXStatisticRequest.h"
#import "YXGetRequest.h"

@interface YXStatisticRequest()


@end

@implementation YXStatisticRequest

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"mId":@"id"}];
}

#pragma mark-
- (instancetype)init
{
    if (self = [super init]) {
        self.osType = nil;
        self.version = nil;
        self.token = nil;
        self.urlHead = @"http://boss.shangruitong.com/logup";
    }
    return self;
}

- (void)updateRequestUrlAndParams {
    [self request].url = [NSURL URLWithString:self.urlHead];
    NSString *content = [NSString stringWithFormat:@"{\"content\":[%@]}", self.content];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [[self request] setPostFormat:ASIMultipartFormDataPostFormat];
    [[self request] setPostBody:[NSMutableData dataWithData:data]];
}

//- (void)updateRequestUrlAndParams {
//    [self request].url = [NSURL URLWithString:self.urlHead];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
//    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    //str = [self stringByEscapingForURLArgument:str];
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    
//    //NSData *data = [NSData dataWithContentsOfFile:path];
//    [[self request] setPostFormat:ASIMultipartFormDataPostFormat];
//    [[self request] setPostBody:data];
//    
//}

@end
