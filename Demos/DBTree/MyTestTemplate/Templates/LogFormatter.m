//
//  LogFormatter.m
//  MyTest
//
//  Created by CaiLei on 12/4/14.
//  Copyright (c) 2014 leso. All rights reserved.
//

#import "LogFormatter.h"

@implementation LogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    return [NSString stringWithFormat:@"%-20s %-15@ %4lu | %@",
            [[logMessage->_file lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding],
            logMessage->_function,
            (unsigned long)logMessage->_line,
            logMessage->_message];
}

@end
