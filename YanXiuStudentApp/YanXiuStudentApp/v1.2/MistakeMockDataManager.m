//
//  MistakeMockDataManager.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 4/5/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeMockDataManager.h"

@implementation MistakeMockDataManager
+ (NSString *)getJsonData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MistakeMockData" ofType:@"geojson"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}
@end
