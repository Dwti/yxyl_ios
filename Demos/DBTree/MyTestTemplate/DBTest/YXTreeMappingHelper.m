//
//  YXTreeMappingHelper.m
//  testPods
//
//  Created by Lei Cai on 10/30/15.
//  Copyright © 2015 yanxiu. All rights reserved.
//

#import "YXTreeMappingHelper.h"
@interface YXTreeMappingHelper ()
//@property (nonatomic, copy) NSString* fromClassName;
//@property (nonatomic, copy) NSString* toClassName;
//@property (nonatomic, copy) NSString* fromIDName;
//@property (nonatomic, copy) NSString* toIDName;
//@property (nonatomic, copy) NSString* fromNameName;
//@property (nonatomic, copy) NSString* toNameName;
//@property (nonatomic, copy) NSString* fromSubNodesName;
//@property (nonatomic, copy) NSString* toSubNodesName;
@end

@implementation YXTreeMappingHelper

- (id)giveMeTreeFromTree:(id)root {
    Class toClass = NSClassFromString(self.toClassName);
    id newRoot = [[toClass alloc] init];
    id fromID = [root valueForKey:self.fromIDName];
    id fromName = [root valueForKey:self.fromNameName];
    NSArray *fromSubNodes = [root valueForKey:self.fromSubNodesName];
    if (!isEmpty(fromID)) {
        [newRoot setValue:fromID forKey:self.toIDName];
    }
    if (!isEmpty(fromName)) {
        [newRoot setValue:fromName forKey:self.toNameName];
    }
    if (!isEmpty(fromSubNodes)) {
        NSMutableArray *newSubNodes = [NSMutableArray array];
        for (id subnode in fromSubNodes) {
            id newSubnode = [self giveMeTreeFromTree:subnode];
            [newSubNodes addObject:newSubnode];
        }
        [newRoot setValue:newSubNodes forKey:self.toSubNodesName];
    }
    
    return newRoot;
}

- (void)swipeFromTo {
    NSMutableArray *tmpArr = [NSMutableArray array];
    [tmpArr addObject:self.fromClassName];
    [tmpArr addObject:self.fromIDName];
    [tmpArr addObject:self.fromNameName];
    [tmpArr addObject:self.fromSubNodesName];
    
    self.fromClassName = self.toClassName;
    self.fromIDName = self.toIDName;
    self.fromNameName = self.toNameName;
    self.fromSubNodesName = self.toSubNodesName;
    
    self.toClassName = tmpArr[0];
    self.toIDName  = tmpArr[1];
    self.toNameName = tmpArr[2];
    self.toSubNodesName = tmpArr[3];
}

@end
