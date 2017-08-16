//
//  AudioManager.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/8/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioManager : NSObject

+ (instancetype)sharedInstance;

- (void)playSoundWithUrl:(NSURL *)url;

@end
