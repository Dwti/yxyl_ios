//
//  MistakeRedoNoteRequest.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/6/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "SaveMistakeNoteRequest.h"

@implementation MistakeRedoNoteItem
@end

@implementation MistakeNote
@end

@implementation SaveMistakeNoteRequest

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"app/q/editUserWrongQNote.do"];
    }
    return self;
}

@end
