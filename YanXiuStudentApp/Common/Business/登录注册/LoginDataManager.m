//
//  LoginDataManager.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/22.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "LoginDataManager.h"
#import "YXRecordManager.h"

NSString *const kBindPhoneSuccessNotification = @"kBindPhoneSuccessNotification";

@interface LoginDataManager ()

@property (nonatomic, strong) YXLoginRequest *loginRequest;
@property (nonatomic, strong) YXResetPasswordRequest *resetPasswordRequest;
@property (nonatomic, strong) RegisterByUserInfoRequest *registerByUserInfoRequest;
@property (nonatomic, strong) YXThirdRegisterRequest *thirdRegisterRequest;
@property (nonatomic, strong) YXProduceCodeRequest *produceCodeRequest;
@property (nonatomic, strong) YXProduceCodeByBindRequest *produceCodeByBindRequest;

@property (nonatomic, strong) YXVerifySMSCodeRequest *verifySMSCodeRequest;
@property (nonatomic, strong) RegisterAccountRequest *registerAccountRequest;
@property (nonatomic, strong) RegisterByJoinClassRequest *registerByJoinClassRequest;
@property (nonatomic, strong) ThirdRegisterByJoinClassRequest *thirdRegisterByJoinClassRequest;
@property (nonatomic, strong) YXModifyPasswordRequest *modifyPasswordRequest;
@property (nonatomic, strong) BindNewMobileRequest *bindNewMobileRequest;
@property (nonatomic, strong) VerifyBindedMobileRequest *verifyBindedMobileRequest;
@end

@implementation LoginDataManager
+ (instancetype)sharedInstance {
    static LoginDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LoginDataManager alloc] init];
    });
    return sharedInstance;
}

+ (void)loginWithMobileNumber:(NSString *)mobileNumber
                     password:(NSString *)password
                 isThirdLogin:(BOOL)isThirdLogin
                completeBlock:(void (^)(YXLoginRequestItem *, NSError *, BOOL))completeBlock {
    LoginDataManager *manger = [LoginDataManager sharedInstance];
    [manger.loginRequest stopRequest];
    manger.loginRequest = [[YXLoginRequest alloc] init];
    manger.loginRequest.mobile = mobileNumber;
    manger.loginRequest.password = password;//[password yx_md5];
    WEAK_SELF
    [manger.loginRequest startRequestWithRetClass:[YXLoginRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        BOOL isBind;
        
        if ((error) && (error.code != 80) /*未绑定也能进去*/) {
            BLOCK_EXEC(completeBlock,retItem,error,NO);
            return;
        }
        
        
        YXLoginRequestItem *item = retItem;
        if ([item.status.code isEqual:@"80"]) {
            isBind = NO;
        }else {
            isBind = YES;
            NSMutableDictionary *counts = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"counts"] mutableCopy];
            if (!counts) {
                counts = [NSMutableDictionary new];
            }
            [counts setValue:password forKey:mobileNumber];
            [[NSUserDefaults standardUserDefaults] setValue:counts forKey:@"counts"];
            [manger saveUserDataWithUserModel:item.data[0] isThirdLogin:isThirdLogin isJoinByClass:NO];
        }
        BLOCK_EXEC(completeBlock,retItem,nil,isBind);
    }];
}

+ (void)touristLoginWithCompleteBlock:(void (^)(YXLoginRequestItem *, NSError *, BOOL))completeBlock {
    WEAK_SELF
    [self loginWithMobileNumber:@"15652513352" password:@"123456" isThirdLogin:YES completeBlock:^(YXLoginRequestItem *item, NSError *error, BOOL isBind) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,item,error,isBind);
            return;
        }
        BLOCK_EXEC(completeBlock,item,nil,isBind);
    }];
}
+ (void)resetPasswordWithMobileNumber:(NSString *)mobileNumber password:(NSString *)password completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    LoginDataManager *manger = [LoginDataManager sharedInstance];
    [manger.resetPasswordRequest stopRequest];
    manger.resetPasswordRequest = [[YXResetPasswordRequest alloc] init];
    manger.resetPasswordRequest.mobile = mobileNumber;
    manger.resetPasswordRequest.password = password;
    WEAK_SELF
    [manger.resetPasswordRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}

+ (void)registerWithModel:(RegisterModel *)registerModel completeBlock:(void (^)(YXRegisterRequestItem *, NSError *))completeBlock {
    LoginDataManager *manger = [LoginDataManager sharedInstance];
    [manger.registerByUserInfoRequest stopRequest];
    manger.registerByUserInfoRequest = [[RegisterByUserInfoRequest alloc] init];
    manger.registerByUserInfoRequest.mobile = registerModel.mobile;
    manger.registerByUserInfoRequest.realname = registerModel.realname;
    manger.registerByUserInfoRequest.provinceid = registerModel.provinceid;
    manger.registerByUserInfoRequest.cityid = registerModel.cityid;
    manger.registerByUserInfoRequest.areaid = registerModel.areaid;
    manger.registerByUserInfoRequest.stageid = registerModel.stageid;
    manger.registerByUserInfoRequest.schoolName = registerModel.schoolName;
    manger.registerByUserInfoRequest.schoolid = registerModel.schoolid;
    manger.registerByUserInfoRequest.validKey = registerModel.validKey;
    WEAK_SELF
    [manger.registerByUserInfoRequest startRequestWithRetClass:[YXRegisterRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        YXRegisterRequestItem *item = retItem;
        [manger saveUserDataWithUserModel:item.data[0] isThirdLogin:NO isJoinByClass:NO];
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}

+ (void)thirdRegisterWithModel:(ThirdRegisterModel *)thirdRegisterModel completeBlock:(void (^)(YXThirdRegisterRequestItem *, NSError *))completeBlock {
    LoginDataManager *manger = [LoginDataManager sharedInstance];
    [manger.thirdRegisterRequest stopRequest];
    manger.thirdRegisterRequest = [[YXThirdRegisterRequest alloc] init];
    manger.thirdRegisterRequest.openid = thirdRegisterModel.openid;
    manger.thirdRegisterRequest.pltform = thirdRegisterModel.pltform;
    manger.thirdRegisterRequest.sex = thirdRegisterModel.sex;
    manger.thirdRegisterRequest.headimg = thirdRegisterModel.headimg;
    manger.thirdRegisterRequest.unionId = thirdRegisterModel.unionId;
    manger.thirdRegisterRequest.realname = thirdRegisterModel.realname;
    manger.thirdRegisterRequest.provinceid = thirdRegisterModel.provinceid;
    manger.thirdRegisterRequest.cityid = thirdRegisterModel.cityid;
    manger.thirdRegisterRequest.areaid = thirdRegisterModel.areaid;
    manger.thirdRegisterRequest.stageid = thirdRegisterModel.stageid;
    manger.thirdRegisterRequest.schoolname = thirdRegisterModel.schoolname;
    manger.thirdRegisterRequest.schoolid = thirdRegisterModel.schoolid;
    WEAK_SELF
    [manger.thirdRegisterRequest startRequestWithRetClass:[YXThirdRegisterRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        YXThirdRegisterRequestItem *item = retItem;
        [manger saveUserDataWithUserModel:item.data[0] isThirdLogin:YES isJoinByClass:NO];
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}

+ (void)getVerifyCodeWithMobileNumber:(NSString *)mobileNumber verifyType:(NSString *)verifyType completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    LoginDataManager *manger = [LoginDataManager sharedInstance];
    [manger.produceCodeRequest stopRequest];
    manger.produceCodeRequest = [[YXProduceCodeRequest alloc] init];
    manger.produceCodeRequest.mobile = mobileNumber;
    manger.produceCodeRequest.type = verifyType;
    WEAK_SELF
    [manger.produceCodeRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}

+ (void)getVerifyCodeByBindWithMobileNumber:(NSString *)mobileNumber verifyType:(NSString *)verifyType completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    LoginDataManager *manger = [LoginDataManager sharedInstance];
    [manger.produceCodeByBindRequest stopRequest];
    manger.produceCodeByBindRequest = [[YXProduceCodeByBindRequest alloc] init];
    manger.produceCodeByBindRequest.mobile = mobileNumber;
    manger.produceCodeByBindRequest.type = verifyType;
    WEAK_SELF
    [manger.produceCodeByBindRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}


+ (void)verifySMSCodeWithMobileNumber:(NSString *)mobileNumber verifyCode:(NSString *)verifyCode codeType:(NSString *)codeType completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    LoginDataManager *manger = [LoginDataManager sharedInstance];
    [manger.verifySMSCodeRequest stopRequest];
    manger.verifySMSCodeRequest = [[YXVerifySMSCodeRequest alloc] init];
    manger.verifySMSCodeRequest.mobile = mobileNumber;
    manger.verifySMSCodeRequest.code = verifyCode;
    manger.verifySMSCodeRequest.type = codeType;
    WEAK_SELF
    [manger.verifySMSCodeRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}

+ (void)verifyBindedMobileNumber:(NSString *)mobileNumber verifyCode:(NSString *)verifyCode completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    LoginDataManager *manger = [LoginDataManager sharedInstance];
    [manger.verifyBindedMobileRequest stopRequest];
    manger.verifyBindedMobileRequest = [[VerifyBindedMobileRequest alloc] init];
    manger.verifyBindedMobileRequest.mobile = mobileNumber;
    manger.verifyBindedMobileRequest.code = verifyCode;
    WEAK_SELF
    [manger.verifyBindedMobileRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}

+ (void)bindNewMobileWithNumber:(NSString *)mobileNumber verifyCode:(NSString *)verifyCode completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    LoginDataManager *manger = [LoginDataManager sharedInstance];
    [manger.bindNewMobileRequest stopRequest];
    manger.bindNewMobileRequest = [[BindNewMobileRequest alloc] init];
    manger.bindNewMobileRequest.mobile = mobileNumber;
    manger.bindNewMobileRequest.code = verifyCode;
    WEAK_SELF
    [manger.bindNewMobileRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        [YXUserManager sharedManager].userModel.mobile = mobileNumber;
        BLOCK_EXEC(completeBlock,retItem,nil);
        [[NSNotificationCenter defaultCenter]postNotificationName:kBindPhoneSuccessNotification object:nil];
    }];
}

+ (void)registerAccountWithModel:(AccountRegisterModel *)accountRegisterModel completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    LoginDataManager *manger = [LoginDataManager sharedInstance];
    [manger.registerAccountRequest stopRequest];
    manger.registerAccountRequest = [[RegisterAccountRequest alloc] init];
    manger.registerAccountRequest.mobile = accountRegisterModel.mobile;
    manger.registerAccountRequest.password = accountRegisterModel.password;
    manger.registerAccountRequest.code = accountRegisterModel.code;
    manger.registerAccountRequest.type = accountRegisterModel.type;
    WEAK_SELF
    [manger.registerAccountRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
        [YXRecordManager addRecordWithType:YXRecordResigerType];
    }];
}

+ (void)registerByJoinClassWithModel:(RegisterByJoinClassModel *)registerByJoinClassModel completeBlock:(void (^)(RegisterRequestItem *, NSError *))completeBlock {
    LoginDataManager *manger = [LoginDataManager sharedInstance];
    [manger.registerByJoinClassRequest stopRequest];
    manger.registerByJoinClassRequest = [[RegisterByJoinClassRequest alloc] init];
    manger.registerByJoinClassRequest.mobile = registerByJoinClassModel.mobile;
    manger.registerByJoinClassRequest.realname = registerByJoinClassModel.realname;
    manger.registerByJoinClassRequest.provinceid = registerByJoinClassModel.provinceid;
    manger.registerByJoinClassRequest.cityid = registerByJoinClassModel.cityid;
    manger.registerByJoinClassRequest.areaid = registerByJoinClassModel.areaid;
    manger.registerByJoinClassRequest.stageid = registerByJoinClassModel.stageid;
    manger.registerByJoinClassRequest.schoolName = registerByJoinClassModel.schoolName;
    manger.registerByJoinClassRequest.schoolid = registerByJoinClassModel.schoolid;
    manger.registerByJoinClassRequest.classId = registerByJoinClassModel.classId;
    manger.registerByJoinClassRequest.validKey = registerByJoinClassModel.validKey;
    WEAK_SELF
    [manger.registerByJoinClassRequest startRequestWithRetClass:[RegisterRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        RegisterRequestItem *item = retItem;
        [manger saveUserDataWithUserModel:item.data[0] isThirdLogin:NO isJoinByClass:YES];
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}

+ (void)thirdRegisterByJoinClassWithModel:(ThirdRegisterByJoinClassModel *)thirdRegisterByJoinClassModel completeBlock:(void (^)(ThirdRegisterRequestItem *, NSError *))completeBlock {
    LoginDataManager *manger = [LoginDataManager sharedInstance];
    [manger.thirdRegisterByJoinClassRequest stopRequest];
    manger.thirdRegisterByJoinClassRequest = [[ThirdRegisterByJoinClassRequest alloc] init];
    manger.thirdRegisterByJoinClassRequest.openid = thirdRegisterByJoinClassModel.openid;
    manger.thirdRegisterByJoinClassRequest.pltform = thirdRegisterByJoinClassModel.pltform;
    manger.thirdRegisterByJoinClassRequest.sex = thirdRegisterByJoinClassModel.sex;
    manger.thirdRegisterByJoinClassRequest.headimg = thirdRegisterByJoinClassModel.headimg;
    manger.thirdRegisterByJoinClassRequest.realname = thirdRegisterByJoinClassModel.realname;
    manger.thirdRegisterByJoinClassRequest.provinceid = thirdRegisterByJoinClassModel.provinceid;
    manger.thirdRegisterByJoinClassRequest.cityid = thirdRegisterByJoinClassModel.cityid;
    manger.thirdRegisterByJoinClassRequest.areaid = thirdRegisterByJoinClassModel.areaid;
    manger.thirdRegisterByJoinClassRequest.stageid = thirdRegisterByJoinClassModel.stageid;
    manger.thirdRegisterByJoinClassRequest.schoolname = thirdRegisterByJoinClassModel.schoolname;
    manger.thirdRegisterByJoinClassRequest.schoolid = thirdRegisterByJoinClassModel.schoolid;
    manger.thirdRegisterByJoinClassRequest.classId = thirdRegisterByJoinClassModel.classId;
    
    WEAK_SELF
    [manger.thirdRegisterByJoinClassRequest startRequestWithRetClass:[ThirdRegisterRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        RegisterRequestItem *item = retItem;
        [manger saveUserDataWithUserModel:item.data[0] isThirdLogin:YES isJoinByClass:YES];
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}

+ (void)modifyPasswordWithOldPassword:(NSString *)oldPassword
                          newPassword:(NSString *)newPassword
                        completeBlock:(void (^)(YXModifyPasswordItem *, NSError *))completeBlock {
    LoginDataManager *manger = [LoginDataManager sharedInstance];
    [manger.modifyPasswordRequest stopRequest];
    manger.modifyPasswordRequest = [[YXModifyPasswordRequest alloc] init];
    manger.modifyPasswordRequest.mobile = [YXUserManager sharedManager].userModel.mobile;
    manger.modifyPasswordRequest.loginName = [YXUserManager sharedManager].userModel.passport.loginName;
    manger.modifyPasswordRequest.oldPass = oldPassword;
    manger.modifyPasswordRequest.myNewPass = newPassword;
    WEAK_SELF
    [manger.modifyPasswordRequest startRequestWithRetClass:[YXModifyPasswordItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        YXModifyPasswordItem *item = retItem;
        [YXUserManager sharedManager].userModel.passport = item.data[0];
        [[YXUserManager sharedManager] saveUserData];
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}

- (void)saveUserDataWithUserModel:(YXUserModel *)model
                     isThirdLogin:(BOOL)isThirdLogin
                    isJoinByClass:(BOOL)isJoinByClass
{
    [YXUserManager sharedManager].userModel = model;
    [[YXUserManager sharedManager] setIsThirdLogin:isThirdLogin];
    [[YXUserManager sharedManager] setIsRegisterByJoinClass:isJoinByClass];
    [[YXUserManager sharedManager] login];
}
@end
