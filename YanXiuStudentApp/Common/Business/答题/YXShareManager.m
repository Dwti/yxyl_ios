 //
//  YXShareManager.m
//  YanXiuStudentApp
//
//  Created by wd on 15/10/27.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXShareManager.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "YXQAPaperStaticticData.h"

@implementation YXShareManager

+ (instancetype) shareManager
{
    static YXShareManager* _sharedManager = nil;
    static dispatch_once_t _onceToken = 0;
    
    dispatch_once (&_onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

#pragma mark Class Metheds
+ (BOOL)isWXAppSupport
{
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

+ (BOOL)isQQSupport
{
    return [QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi];
}

#pragma mark Public
- (void)shareWithType:(YXShareType)shareType model:(QAPaperModel *)model networkErrorBlock:(void(^)(void))networkErrorBlock{
    if (![self isNetworkReachable]) {
        networkErrorBlock();
        return;
    }
    YXQAPaperStaticticData * statisticData = [YXQAPaperStaticticData dataFromQAModel:model];
    NSString * shareUrlFormat = @"http://wx.hwk.yanxiu.com/sharePage.do?uid=%@&ppid=%@&buildtime=%@&ostype=%@";
    NSString * shareURL = [NSString stringWithFormat:shareUrlFormat,[YXUserManager sharedManager].userModel.uid,model.paperID,@(model.paperCreatingTime),[YXConfigManager sharedInstance].deviceName];
    NSString * message = @"";
    float correctPercent = (float)statisticData.corrected/statisticData.total;
    long int correct =  lroundf(correctPercent * 100);
    
    if (correct > 80) {
        message = @"还有谁？！学霸就是我，我就是学霸，不服来战！";
    }else if(correct > 60){
        message = @"满分会是坚持的人最后获得的奖赏，求见证！";
    }else if(correct > 20){
        message = @"成长的路还很长，我在加油，你在干嘛？";
    }else{
        message = @"冰冻三尺非一日之寒，求鞭策！";
    }
    [[YXShareManager shareManager] yx_shareMessageWithImageIcon:[UIImage imageNamed:@"icon_login_logo"] title:@"练习报告" message:message url:shareURL shareType:shareType];
}

- (void)yx_shareMessageWithImageIcon:(UIImage *)icon title:(NSString *)title message:(NSString *)message url:url shareType:(YXShareType)type
{
    switch (type) {
        case YXShareType_WeChat:
        {
            [self shareMessageToWechartWithImageIcon:icon title:title message:message url:url];
        }
            break;
        case YXShareType_WeChatFriend:
        {
            [self shareMessageToWechartFriendWithImageIcon:icon title:title message:message url:url];
        }
            break;
        case YXShareType_TcQQ:
        {
            [self shareMessageToQQWithImageIcon:icon title:title message:message url:url];
        }
            break;
        case YXShareType_TcZone:
        {
            [self shareMessageToQQZoneWithImageIcon:icon title:title message:message url:url];
        }
            break;
        default:
            break;
    }
}

#pragma mark Private
- (void)shareMessageToWechartWithImageIcon:(UIImage *)icon title:(NSString *)title message:(NSString *)message url:(NSString *)url
{
    WXMediaMessage * wxMessage = [WXMediaMessage message];
    
    wxMessage.title = title;
    wxMessage.description = message;
    [wxMessage setThumbImage:icon];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    wxMessage.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = wxMessage;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void)shareMessageToWechartFriendWithImageIcon:(UIImage *)icon title:(NSString *)title message:(NSString *)message url:(NSString *)url
{
    WXMediaMessage * wxMessage = [WXMediaMessage message];
    
    wxMessage.title = message;
//    wxMessage.description = message;
    [wxMessage setThumbImage:icon];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    wxMessage.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = wxMessage;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

- (void)shareMessageToQQWithImageIcon:(UIImage *)icon title:(NSString *)title message:(NSString *)message url:(NSString *)url
{
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:url]
                                title:title
                                description:message
                                previewImageData:UIImagePNGRepresentation(icon)];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    [QQApiInterface sendReq:req];
}

- (void)shareMessageToQQZoneWithImageIcon:(UIImage *)icon title:(NSString *)title message:(NSString *)message url:(NSString *)url
{
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:url]
                                title:title
                                description:message
                                previewImageData:UIImagePNGRepresentation(icon)];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qzone
    [QQApiInterface SendReqToQZone:req];
}

#pragma mark- NewShare

+ (void)yx_shareMessageWithImageIconNamePath:(NSString *)iconPath picture:(UIImage *)picture title:(NSString *)title message:(NSString *)message shareType:(YXShareType)type
{
    //UIImage *icon = [UIImage imageWithContentsOfFile:iconPath];
    NSData *iconData = [NSData dataWithContentsOfFile:iconPath];
    switch (type) {
        case YXShareType_WeChat:
        {
            [self shareMessageToWechartWithImageData:iconData picture:picture title:title message:message];
        }
            break;
        case YXShareType_WeChatFriend:
        {
            [self shareMessageToWechartFriendWithImageIcon:nil picture:picture title:title message:message];
        }
            break;
        case YXShareType_TcQQ:
        {
            [self shareMessageToQQWithImageIcon:nil picture:picture title:title message:message ];
        }
            break;
        case YXShareType_TcZone:
        {
            [self shareMessageToQQZoneWithImageIcon:nil picture:picture title:title message:message];
        }
            break;
        default:
            break;
    }
}


+ (void)yx_shareMessageWithImageIcon:(UIImage *)icon picture:(UIImage *)picture title:(NSString *)title message:(NSString *)message shareType:(YXShareType)type
{
    switch (type) {
        case YXShareType_WeChat:
        {
            [self shareMessageToWechartWithImageIcon:icon picture:picture title:title message:message];
        }
            break;
        case YXShareType_WeChatFriend:
        {
            [self shareMessageToWechartFriendWithImageIcon:icon picture:picture title:title message:message];
        }
            break;
        case YXShareType_TcQQ:
        {
            [self shareMessageToQQWithImageIcon:icon picture:picture title:title message:message ];
        }
            break;
        case YXShareType_TcZone:
        {
            [self shareMessageToQQZoneWithImageIcon:icon picture:picture title:title message:message];
        }
            break;
        default:
            break;
    }
}

+ (void)shareMessageToWechartWithImageData:(NSData *)iconData picture:(UIImage *)picture title:(NSString *)title message:(NSString *)message
{
    WXMediaMessage * wxMessage = [WXMediaMessage message];
    
    wxMessage.title = title;
    wxMessage.description = message;
    [wxMessage setThumbData:iconData];
    
    WXImageObject *wxImage = [WXImageObject new];
    wxImage.imageData = UIImagePNGRepresentation(picture);
    
    wxMessage.mediaObject = wxImage;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = wxMessage;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}


+ (void)shareMessageToWechartWithImageIcon:(UIImage *)icon picture:(UIImage *)picture title:(NSString *)title message:(NSString *)message
{
    WXMediaMessage * wxMessage = [WXMediaMessage message];
    
    wxMessage.title = title;
    wxMessage.description = message;
    //[wxMessage setThumbImage:icon];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"唯快不破i" ofType:@"jpg"];
//    [wxMessage setThumbData:[NSData dataWithContentsOfFile:path]];
    
    NSData *data = UIImageJPEGRepresentation(icon, 1);
    [wxMessage setThumbData:data];
    
    WXImageObject *wxImage = [WXImageObject new];
    wxImage.imageData = UIImagePNGRepresentation(picture);
    
    wxMessage.mediaObject = wxImage;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = wxMessage;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

+ (void)shareMessageToWechartFriendWithImageIcon:(UIImage *)icon picture:(UIImage *)picture title:(NSString *)title message:(NSString *)message
{
    WXMediaMessage * wxMessage = [WXMediaMessage message];
    
    wxMessage.title = message;
    //    wxMessage.description = message;
    [wxMessage setThumbImage:icon];
    
    /**
     *  实际上缩略图显示的是picture
     */
    WXImageObject *wxImage = [WXImageObject new];
    wxImage.imageData = UIImagePNGRepresentation(picture);
    
    wxMessage.mediaObject = wxImage;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = wxMessage;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

+ (void)shareMessageToQQWithImageIcon:(UIImage *)icon picture:(UIImage *)picture title:(NSString *)title message:(NSString *)message
{
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(picture)
                                               previewImageData:UIImagePNGRepresentation(icon)
                                                          title:title
                                                   description :message];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    [QQApiInterface sendReq:req];
    
}

+ (void)shareMessageToQQZoneWithImageIcon:(UIImage *)icon picture:(UIImage *)picture title:(NSString *)title message:(NSString *)message
{
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(picture)
                                               previewImageData:UIImagePNGRepresentation(icon)
                                                          title:title
                                                   description :message];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    //将内容分享到qzone
    [QQApiInterface SendReqToQZone:req];
}

@end
