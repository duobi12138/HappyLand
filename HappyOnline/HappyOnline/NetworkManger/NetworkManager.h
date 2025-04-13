//
//  NetworkManager.h
//  HappyOnline
//
//  Created by 多比 on 2025/4/1.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;

NS_ASSUME_NONNULL_BEGIN

typedef void (^CompletionHandler)(id _Nullable responseObject, NSError * _Nullable error);

@interface NetworkManager : NSObject

// 声明 sessionManager 属性
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

+ (instancetype)sharedManager;

// 其他方法声明
- (void)sendVerificationCodeToEmail:(NSString *)email completion:(CompletionHandler)completion;

- (void)registerWithNickname:(NSString *)nickname
                    password:(NSString *)password
                       email:(NSString *)email
                       code:(NSString *)code
                  completion:(CompletionHandler)completion;

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(CompletionHandler)completion;

@end

//typedef void (^CompletionHandler)(NSDictionary * _Nullable response, NSError * _Nullable error);
//
//@interface NetworkManager : NSObject
//
//+ (instancetype)sharedManager;
//
////验证码
//- (void)sendVerificationCodeToEmail:(NSString *)email completion:(CompletionHandler)completion;
//
////注册
//- (void)registerWithNickname:(NSString *)nickname
//                        ID:(NSString *)userID
//                  password:(NSString *)password
//                    email:(NSString *)email
//             verificationCode:(NSString *)code
//                  completion:(CompletionHandler)completion;
//
////登录
//- (void)loginWithEmail:(NSString *)email
//         password:(NSString *)password
//       completion:(CompletionHandler)completion;
//
//@end

NS_ASSUME_NONNULL_END
