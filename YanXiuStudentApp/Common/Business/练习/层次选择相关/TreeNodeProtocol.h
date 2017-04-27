//
//  TreeNodeProtocol.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TreeNodeProtocol <NSObject>
@required
- (NSArray *)subNodes;
- (void)setSubNodes:(NSArray *)subNodes;
@end
