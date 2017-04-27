//
//  UploadRequest.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/2/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "UploadRequest.h"

@implementation UploadRequest
- (ASIFormDataRequest *)request {
    if (self->_request) {
        return (ASIFormDataRequest *)self->_request;
    }
    // maybe ASI bug, must initWithURL, init will cause crash after change url later
    self->_request = [[ASIFormDataRequest alloc] initWithURL:nil];
    return (ASIFormDataRequest *)self->_request;
}

- (void)updateRequestUrlAndParams {
    [self request].url = [NSURL URLWithString:[self _generateFullUrl]];
}

@end
