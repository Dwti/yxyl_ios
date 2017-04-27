//
//  GetRequest.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/2/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "GetRequest.h"

@implementation GetRequest
- (ASIHTTPRequest *)request {
    if (self->_request) {
        return self->_request;
    }
    // maybe ASI bug, must initWithURL, init will cause crash after change url later
    self->_request = [[ASIHTTPRequest alloc] initWithURL:nil];
    return self->_request;
}

- (void)updateRequestUrlAndParams {
    [self request].url = [NSURL URLWithString:[self _generateFullUrl]];
    //DDLogWarn(@"%@", [self reqpo uest].url);
    [self request].requestMethod = @"GET";
}
@end
