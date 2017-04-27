//
//  YXTreeMappingHelper.h
//  testPods
//
//  Created by Lei Cai on 10/30/15.
//  Copyright © 2015 yanxiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXTreeMappingHelper : NSObject
@property (nonatomic, copy) NSString* fromClassName;
@property (nonatomic, copy) NSString* toClassName;
@property (nonatomic, copy) NSString* fromIDName;
@property (nonatomic, copy) NSString* toIDName;
@property (nonatomic, copy) NSString* fromNameName;
@property (nonatomic, copy) NSString* toNameName;
@property (nonatomic, copy) NSString* fromSubNodesName;
@property (nonatomic, copy) NSString* toSubNodesName;
/**
 *          From                To
 *  类名:    YXTreeNode          YXAnotherNode
 *  ID:     uid                 anotherID
 *  Name:   name                anotherName
 *  子树:    subNodes            anotherSubNodeArray
 */

@property (nonatomic, strong) NSDictionary *mappingDict;

- (void)swipeFromTo;
- (id)giveMeTreeFromTree:(id)root;
@end
