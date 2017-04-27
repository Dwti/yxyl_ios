//
//  FileLogger.m
//  MyTest
//
//  Created by CaiLei on 12/4/14.
//  Copyright (c) 2014 leso. All rights reserved.
//

#import "FileLogger.h"

@implementation FileLogger

- (void)logMessage:(DDLogMessage *)logMessage
{
    if ((logMessage->_flag == DDLogLevelError) || logMessage->_flag == DDLogLevelVerbose) {
        // 只有在error的时候才记入文件
        [super logMessage:logMessage];
    }
}

@end
