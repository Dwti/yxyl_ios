//
//  ____UITests.m
//  易学易练UITests
//
//  Created by 贾培军 on 16/6/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ____UITests : XCTestCase

@end

@implementation ____UITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    //    [self fuheScroll]; 
//    [self myMistakeList];
//    [self guilei];
    [self paizhao];
}

- (void)paizhao{
    //iphone6
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.navigationBars[@"练习"].buttons[@"出题"] tap];
    [app.navigationBars[@"YXPaperMainView"].buttons[@"添加"] tap];
    [app.sheets[@"添加试题"].buttons[@"问答"] tap];
    [[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element tap];
    [app.buttons[@"进入答题"] tap];
    
//    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
//    [scrollViewsQuery.otherElements.tables.buttons[@"上传答案"] tap];
//    [[[[scrollViewsQuery childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeTable].element tap];
//    [app.buttons[@"PhotoCapture"] tap];
    
}

- (void)guilei
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.navigationBars[@"练习"].buttons[@"出题"] tap];
    [app.navigationBars[@"YXPaperMainView"].buttons[@"添加"] tap];
    [app.sheets[@"添加试题"].buttons[@"填空"] tap];
    [app.buttons[@"进入答题"] tap];
}

- (void)myMistakeList
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.tabBars.otherElements.buttons[@"我的"] tap];
    
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"我的错题"] tap];
    
    [[[XCUIApplication alloc] init].tables.staticTexts[@"英语"] tap];
    
//    [app.tables.staticTexts[@"-- Hello!-- ________.\n"] tap];
//    
//    XCUIElement *element = [[[app.scrollViews childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
//    XCUIElement *table = [element childrenMatchingType:XCUIElementTypeTable].element;
//    [table swipeLeft];
//    [table swipeLeft];
//    [table swipeLeft];
//    [table swipeLeft];
//    [table swipeLeft];
//    [table swipeLeft];
    
    
    
}

/**
 *  复合题滑动
 */
- (void)fuhe{
    // Use recording to get started writing UI tests.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.navigationBars[@"练习"].buttons[@"出题"] tap];
    [app.navigationBars[@"YXPaperMainView"].buttons[@"添加"] tap];
    
    XCUIElementQuery *collectionViewsQuery = (XCUIElementQuery *)app.sheets[@"添加试题"];
    [collectionViewsQuery.buttons[@"判断"] swipeUp];
    [collectionViewsQuery.buttons[@"复合"] tap];
        
    [app.buttons[@"进入答题"] tap];
    
}

/**
 *  复合题滑动
 */
- (void)fuheScroll {
    // Use recording to get started writing UI tests.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.navigationBars[@"练习"].buttons[@"出题"] tap];
    [app.navigationBars[@"YXPaperMainView"].buttons[@"添加"] tap];
    
    XCUIElementQuery *collectionViewsQuery = (XCUIElementQuery *)app.sheets[@"添加试题"];
    [collectionViewsQuery.buttons[@"判断"] swipeUp];
    [collectionViewsQuery.buttons[@"复合"] tap];
    
    
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"复合-阅读理解"] tap];
    
    XCUIElement *staticText = tablesQuery.cells.staticTexts[@"单选-单选题"];
    [staticText swipeLeft];
    [app.tables.buttons[@"删除"] tap];
    
    XCUIElement *navigationBar = app.navigationBars[@"复合题配置"];
    [navigationBar.buttons[@"添加"] tap];
    [app.sheets[@"添加试题"].buttons[@"判断"] tap];
    [[[[navigationBar childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"返回"] elementBoundByIndex:0] tap];
    [app.buttons[@"进入答题"] tap];
    
}

- (void)closeTest {
    
}


@end
