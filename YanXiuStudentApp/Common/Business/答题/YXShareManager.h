//
//  YXShareManager.h
//  YanXiuStudentApp
//
//  Created by wd on 15/10/27.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, YXShareType) {
    YXShareType_WeChat = 0,//微信
    YXShareType_WeChatFriend,//微信朋友圈
    YXShareType_TcQQ,//QQ
    YXShareType_TcZone,//QQ空间
    YXShareType_Cancel,//取消
};

@interface YXShareManager : NSObject

+ (instancetype) shareManager;

+ (BOOL)isWXAppSupport;

+ (BOOL)isQQSupport;

- (void)yx_shareMessageWithImageIcon:(UIImage *)icon title:(NSString *)title message:(NSString *)message url:(NSString *)url shareType:(YXShareType)type;

- (void)shareWithType:(YXShareType)shareType model:(QAPaperModel *)model networkErrorBlock:(void(^)(void))networkErrorBlock;

/**
 *  分享图片
 *
 *  @param icon    缩略图 除了微信分享外其它没用
 *  @param picture 分享的图片
 *  @param title   几乎没用（空值建议传@""）
 *  @param message 几乎没用（空值建议传@""）
 *  @param type    分享类型
 */
+ (void)yx_shareMessageWithImageIcon:(UIImage *)icon picture:(UIImage *)picture title:(NSString *)title message:(NSString *)message shareType:(YXShareType)type;
+ (void)yx_shareMessageWithImageIconNamePath:(NSString *)iconPath picture:(UIImage *)picture title:(NSString *)title message:(NSString *)message shareType:(YXShareType)type;
@end
