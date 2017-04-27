//
//  YXTreeNode.h
//  testPods
//
//  Created by Lei Cai on 10/27/15.
//  Copyright © 2015 yanxiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXTreeNode : NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *subNodes;
@end
