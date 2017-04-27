//
//  YXProvinceList.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/14.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXProvinceList.h"

@implementation YXDistrict

@end

@implementation YXCity

@end

@implementation YXProvince

@end

@interface YXProvinceList ()<NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *parser;

@end

@implementation YXProvinceList

- (void)dealloc
{
    self.parser.delegate = nil;
    self.parser = nil;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"province_data" ofType:@"xml"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        self.parser = [[NSXMLParser alloc] initWithData:data];
        self.parser.delegate = self;
    }
    return self;
}

- (BOOL)startParse
{
    return [self.parser parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.provinces = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"province"]) {
        _currentProvince = [[YXProvince alloc] init];
        _currentProvince.citys = [NSMutableArray array];
        _currentProvince.name = [attributeDict objectForKey:@"name"];
        _currentProvince.pid = [attributeDict objectForKey:@"id"];
    } else if ([elementName isEqualToString:@"city"]) {
        _currentCity = [[YXCity alloc] init];
        _currentCity.districts = [NSMutableArray array];
        _currentCity.name = [attributeDict objectForKey:@"name"];
        _currentCity.cid = [attributeDict objectForKey:@"id"];
    } else if ([elementName isEqualToString:@"district"]) {
        _currentDistrict = [[YXDistrict alloc] init];
        _currentDistrict.name = [attributeDict objectForKey:@"name"];
        _currentDistrict.did = [attributeDict objectForKey:@"id"];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"province"]) {
        [self.provinces addObject:self.currentProvince];
        self.currentProvince = nil;
    } else if ([elementName isEqualToString:@"city"]) {
        [self.currentProvince.citys addObject:self.currentCity];
        self.currentCity = nil;
    } else if ([elementName isEqualToString:@"district"]) {
        [self.currentCity.districts addObject:self.currentDistrict];
        self.currentDistrict = nil;
    }
}

@end
