 
//
//  GlobalUtils.m
//  MyTest
//
//  Created by CaiLei on 12/8/14.
//  Copyright (c) 2014 leso. All rights reserved.
//

#import "GlobalUtils.h"
#import <objc/runtime.h>
#import <DDTTYLogger.h>
#import <DDASLLogger.h>
#import <DDFileLogger.h>
#import "LogFormatter.h"
#import "FileLogger.h"
#import <CommonCrypto/CommonDigest.h>

#import <objc/runtime.h>
#import <Aspects.h>

int ddLogLevel = DDLogLevelVerbose;

@implementation GlobalUtils
+ (void)checkMainThread {
    if ([NSThread currentThread] == [NSThread mainThread]) {
        DDLogWarn(@"main thread");
    } else {
        DDLogWarn(@"other thread");
    }
}

+ (void)setupCore {
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
//        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
//            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
    
    // logger
    LogFormatter *formatter = [[LogFormatter alloc] init];
    
    UIColor *pink = [UIColor colorWithRed:(255 / 255.0) green:(58 / 255.0) blue:(159 / 255.0) alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:DDLogFlagError];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor yellowColor] backgroundColor:nil forFlag:DDLogFlagWarning];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:DDLogFlagDebug];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor orangeColor] backgroundColor:nil forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:pink backgroundColor:nil forFlag:DDLogFlagVerbose];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [[DDASLLogger sharedInstance] setLogFormatter:formatter];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    NSString *logPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    DDLogFileManagerDefault *fm = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:logPath];
    FileLogger *fl = [[FileLogger alloc] initWithLogFileManager:fm];
    [fl setLogFormatter:formatter];
    [DDLog addLogger:fl];
    
    char *xcode_colors = getenv("XcodeColors");
    NSString *xcodecolorsInfo = nil;
    
    if (xcode_colors) {
        if (strcmp(xcode_colors, "YES") == 0) {
            xcodecolorsInfo = @"XcodeColors enabled";
            [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        }
        else {
            xcodecolorsInfo = @"XcodeColors disabled";
        }
    }
    else {
        xcodecolorsInfo = @"XcodeColors not detected";
    }
    
    DDLogVerbose(@"%@", xcodecolorsInfo);
    
    // db
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelOff];
    [MagicalRecord setShouldDeleteStoreOnModelMismatch:YES];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"CoreDataDB.sqlite"];
}

+ (void)clearCore {
    [MagicalRecord cleanUp];
}

+ (void)deliverSelector:(SEL)selector fromObject:(id)fromObj toObject:(id)toObj {
    if (![toObj respondsToSelector:selector]) {
        return;
    }
    
    NSError *error = nil;
    [fromObj aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSString *prefix = @"aspects__";
        NSString *aspectMethodString = NSStringFromSelector(aspectInfo.originalInvocation.selector);
        if ([aspectMethodString hasPrefix:prefix]) {
            // 参考Aspect Method Swizzle的实现
            [aspectInfo.originalInvocation setTarget:toObj];
            [aspectInfo.originalInvocation setSelector:selector];
            [aspectInfo.originalInvocation invoke];
        }
    } error:&error];
    
    if (error) {
        DDLogError(@"hook error : %@", error);
    }
}

#pragma mark - 文件MD5
+ (NSString*)fileMD5:(NSString*)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) return @"ERROR GETTING FILE MD5"; // file didnt exist
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done)
    {
        const NSUInteger CHUNK_SIZE = 1024*8; // 8K
        NSData* fileData = [handle readDataOfLength: CHUNK_SIZE ];
        CC_MD5_Update(&md5, [fileData bytes], (unsigned int)[fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

@end

BOOL isEmpty(id aItem) {
    return aItem == nil
    || ([aItem isKindOfClass:[NSNull class]])
    || (([aItem respondsToSelector:@selector(length)])
        && ([aItem length] == 0))
    || (([aItem respondsToSelector:@selector(length)])
        && ([aItem length] == 0))
    || (([aItem respondsToSelector:@selector(count)])
        && ([aItem count] == 0));
    
}

void Swizzle(Class c, SEL orig, SEL newField)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, newField);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, newField, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}
