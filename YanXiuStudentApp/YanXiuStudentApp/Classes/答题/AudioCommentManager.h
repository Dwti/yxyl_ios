//
//  VoicePlayerManager.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/20/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioCommentManager : NSObject
@property (nonatomic, strong) NSMutableArray *itemArray;
- (void)setup;
- (void)stopPlayAll;
@end
