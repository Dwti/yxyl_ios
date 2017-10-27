//
//  AudioAttachment.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/10/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "AudioAttachment.h"

@implementation AudioAttachment

- (id)initWithElement:(DTHTMLElement *)element options:(NSDictionary *)options
{
    self = [super initWithElement:element options:options];
    
    if (self)
    {
        [self _decodeUrlFromElement:element options:options];
    }
    
    return self;
}
- (void)_decodeUrlFromElement:(DTHTMLElement *)element options:(NSDictionary *)options {
    NSString *src = [element.attributes objectForKey:@"src"];
    self.contentURL = [NSURL URLWithString:src];
}

@end
