//
//  YXAutoGoNextDelegate.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/16/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YXAutoGoNextDelegate <NSObject>
- (void)autoGoNextGoGoGo;
@optional
- (void)cancelAnswer;
@end
