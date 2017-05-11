//
//  HttpBaseRequest.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/2/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "HttpBaseRequest.h"

NSString *const YXTokenInValidNotification = @"kYXTokenInValidNotification";

#pragma mark - Url Arguments Category : NSString & NSDictionary
@interface NSDictionary (UrlArgumentsAdditions)
- (NSString *)httpArgumentsString;
@end

@interface NSString (UrlArgumentsAdditions)
- (NSString*)stringByEscapingForURLArgument;
- (NSString*)stringByUnescapingFromURLArgument;
@end



@implementation NSString (UrlArgumentsAdditions)
- (NSString*)stringByEscapingForURLArgument {
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8);
}

- (NSString*)stringByUnescapingFromURLArgument {
    NSMutableString *resultString = [NSMutableString stringWithString:self];
    [resultString replaceOccurrencesOfString:@"+"
                                  withString:@" "
                                     options:NSLiteralSearch
                                       range:NSMakeRange(0, [resultString length])];
    return [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end

@implementation NSDictionary (UrlArgumentsAdditions)
- (NSString *)httpArgumentsString {
    NSMutableArray* arguments = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSString *key in self.allKeys) {
        [arguments addObject:[NSString stringWithFormat:@"%@=%@",
                              [key stringByEscapingForURLArgument],
                              [[[self objectForKey:key] description] stringByEscapingForURLArgument]]];
    }
    
    return [arguments componentsJoinedByString:@"&"];
}
@end



#pragma mark -
@implementation HttpBaseRequestItem_Status
@end

@implementation HttpBaseRequestItem
@end

@implementation HttpBaseRequest
- (ASIHTTPRequest *)request {
    return nil; // 子类实现, GET / POST / UPLOAD
}

- (void)updateRequestUrlAndParams {
    
}

- (void)startRequestWithRetClass:(Class)retClass
                andCompleteBlock:(HttpRequestCompleteBlock)completeBlock {
    self->_completeBlock = completeBlock;
    self->_retClass = retClass;
    [self updateRequestUrlAndParams];
    DDLogWarn(@"request : %@", [self request].url);
    @weakify(self);
    [[self request] setCompletionBlock:^{
        @strongify(self); if (!self) return;
        NSString *json = [[NSString alloc] initWithData:[self request].responseData encoding:NSUTF8StringEncoding];
        [self dealWithResponseJson:json];
    }];
    [[self request] setFailedBlock:^{
        @strongify(self); if (!self) return;
        NSError *error = [self request].error;
        if (error
            && [error.domain isEqualToString:NetworkRequestErrorDomain]) {
            NSString *title = @"";
            if (error.code == ASIConnectionFailureErrorType) {
                title = @"网络未连接，请检查后重试";
            } else if (error.code == ASIRequestTimedOutErrorType) {
                title = @"网络未连接，请检查后重试";
            }
            error = [NSError errorWithDomain:NetworkRequestErrorDomain code:ASIConnectionFailureErrorType userInfo:@{NSLocalizedDescriptionKey:title}]; // 网络异常提示
        }
        self->_completeBlock(nil, error);
    }];
    
    [[self request] startAsynchronous];
}

- (void)stopRequest {
    [[self request] clearDelegatesAndCancel];
}

// 约定server返回的业务逻辑错误为非负整数
- (void)dealWithResponseJson:(NSString *)json
{
    // TBD : cailei , 效率原因应该实现于各个子类，参看YXGetWrongQRequest，由于server暂时没有给出加密接口的list，所以先用此通用方法
//    NSString *decrypt = [YXCrypt decryptForString:json];
//    if (!isEmpty(decrypt)) {
//        json = decrypt;
//    } else {
//        json = json;
//    }

    // 解码对象不存在，直接返回json数据
    if (!_retClass || ![_retClass isSubclassOfClass:[JSONModel class]]) {
        _completeBlock(json, nil);
        return;
    }
    
    NSError *error = nil;
    HttpBaseRequestItem *item = [[_retClass alloc] initWithString:json error:&error];
    // json格式错误
    if (error) {
        error = [NSError errorWithDomain:error.domain code:-1 userInfo:@{NSLocalizedDescriptionKey:@"出错了，请稍后再试"}];
        _completeBlock(nil, error);
        return;
    }
    
    // token失效
    if (item.status.code.integerValue==99 && [YXUserManager sharedManager].userModel.passport.token) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YXTokenInValidNotification
                                                            object:nil];
        return;
    }
    
    // 业务逻辑错误
    if (item.status.code.integerValue != 0) {
        error = [NSError errorWithDomain:@"network" code:item.status.code.integerValue userInfo:@{NSLocalizedDescriptionKey: item.status.desc ?:@"请求失败"}];
        _completeBlock(item, error);
        return;
    }
    
    // 正常数据
    _completeBlock(item, nil);
}

#pragma mark - private
- (NSDictionary *)_paramDict {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSDictionary *dict = [self toDictionary];
    for (NSString *key in [dict allKeys]) {
        id value = [dict valueForKey:key];
        if (isEmpty(value) && [value isKindOfClass:[NSNull class]]) {
            continue;
        }
        [paramDict setValue:value forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:paramDict];
}

- (NSString *)_generateFullUrl {
    NSDictionary *paramDict = [self _paramDict];
    NSString *url = self.urlHead;
    if (!isEmpty(paramDict)) {
        url = [url stringByAppendingString:@"?"];
        url = [url stringByAppendingString:[paramDict httpArgumentsString]];
    }
    return url;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
    if ([propertyName isEqualToString: @"retryTimes"]) return YES;
    if ([propertyName isEqualToString: @"retryTimeinterval"]) return YES;
    if ([propertyName isEqualToString: @"request"]) return YES;
    if ([propertyName isEqualToString: @"completionBlock"]) return YES;
    if ([propertyName isEqualToString: @"requestType"]) return YES;
    if ([propertyName isEqualToString: @"bNeedRecord"]) return YES;
    return NO;
}

@end
