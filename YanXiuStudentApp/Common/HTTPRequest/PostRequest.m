//
//  PostRequest.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/2/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "PostRequest.h"

@implementation PostRequest
- (ASIFormDataRequest *)request {
    if (self->_request) {
        return (ASIFormDataRequest *)self->_request;
    }
    // maybe ASI bug, must initWithURL, init will cause crash after change url later
    self->_request = [[ASIFormDataRequest alloc] initWithURL:nil];
    return (ASIFormDataRequest *)self->_request;
}

- (void)updateRequestUrlAndParams {
    [self request].url = [NSURL URLWithString:self.urlHead];
    NSDictionary *paramDict = [self _paramDict];
    for (NSString *key in [paramDict allKeys]) {
        NSString *value = [paramDict objectForKey:key];
        [[self request] setPostValue:value forKey:key];
    }
    
    
    
}

@end
