//
//  CloneCategory.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CloneProtocol <NSObject>
- (id)clone;
@end

@interface UIView (Clone) <CloneProtocol>
@end

@interface UILabel (Clone) <CloneProtocol>
@end

@interface UIButton (Clone) <CloneProtocol>
@end

