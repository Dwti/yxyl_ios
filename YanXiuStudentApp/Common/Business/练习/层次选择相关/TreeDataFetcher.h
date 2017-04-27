//
//  TreeDataFetcher.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TreeDataBlock) (NSArray *treeNodes, NSError *error); // node element must conforms TreeNodeProtocol protocol

@interface TreeDataFetcher : NSObject
- (void)fetchTreeDataWithCompleteBlock:(TreeDataBlock)completeBlock;
@end
