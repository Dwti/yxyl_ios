//
//  YXUserStatisticsTests.m
//  YXUserStatisticsTests
//
//  Created by ChenJianjun on 16/5/26.
//  Copyright © 2016年 yanxiu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YXUserStatisticsConfig.h"

@interface YXUserStatisticsTests : XCTestCase

@end

@implementation YXUserStatisticsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSDictionary *configDict = [YXUserStatisticsConfig configPlist];
    XCTAssertNotNil(configDict, @"YXUserStatisticsConfig.plist加载失败");
    
    [configDict enumerateKeysAndObjectsUsingBlock:^(NSString *targetPageName, id obj, BOOL *stop) {
        XCTAssert([obj isKindOfClass:[NSDictionary class]], @"plist文件结构可能已经改变，请确认");
        Class pageClass = NSClassFromString(targetPageName);
        id pageInstance = [[pageClass alloc] init];
        
        //方法名、事件Id键值对
        NSDictionary *methodNamesForEventIds = obj;
        [methodNamesForEventIds enumerateKeysAndObjectsUsingBlock:^(NSString *methodName, id obj, BOOL * _Nonnull stop) {
            XCTAssert([obj isKindOfClass:[NSString class]], @"plist文件结构可能已经改变，请确认");
            SEL methodSel = NSSelectorFromString(methodName);
            XCTAssert([pageInstance respondsToSelector:methodSel], @"代码与plist文件方法名不匹配，请确认：-[%@ %@]", targetPageName, methodName);
            
            XCTAssert([YXUserStatisticsConfig isValidEventId:obj], @"EVENT_ID非法，请确认");
            XCTAssertNotNil(obj, @"EVENT_ID为空，请确认");
        }];
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
