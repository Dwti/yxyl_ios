//
//  GlobalUtils.h
//  MyTest
//
//  Created by CaiLei on 12/8/14.
//  Copyright (c) 2014 leso. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 宏

#define SAFE_CALL(obj,method) \
([obj respondsToSelector:@selector(method)] ? [obj method] : nil)

#define SAFE_CALL_OneParam(obj,method,firstParam) \
([obj respondsToSelector:@selector(method:)] ? [obj method:firstParam] : nil)

#define WEAK_SELF @weakify(self);
#define STRONG_SELF @strongify(self); if(!self) {return;};

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); }; 

#define SCREEN_WIDTH          ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT         ([UIScreen mainScreen].bounds.size.height)

@interface GlobalUtils : NSObject
+ (void)checkMainThread;
+ (void)setupCore;
+ (void)clearCore;

+ (void)deliverSelector:(SEL)selector fromObject:(id)fromObj toObject:(id)toObj;
@end

#ifdef __cplusplus
extern "C" {
#endif
    BOOL isEmpty(id aItem);
    void Swizzle(Class c, SEL orig, SEL newField);
#ifdef __cplusplus
}
#endif