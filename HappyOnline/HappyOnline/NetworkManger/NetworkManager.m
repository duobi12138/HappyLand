//
//  NetworkManager.m
//  HappyOnline
//
//  Created by 多比 on 2025/4/1.
//


#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation NetworkManager

+ (instancetype)sharedManager {
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        // 配置AFHTTPSessionManager
        sharedInstance.sessionManager = [AFHTTPSessionManager manager];
        sharedInstance.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        sharedInstance.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        sharedInstance.sessionManager.requestSerializer.timeoutInterval = 15.0;
    });
    return sharedInstance;
}

#pragma mark - 验证码
- (void)sendVerificationCodeToEmail:(NSString *)email
                         completion:(void(^)(id responseObject, NSError *error))completion {
    // 1. 创建 AFHTTPSessionManager 实例
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // 解析 JSON 响应
    
    // 2. 构建请求 URL（GET 请求，参数通过 URL 传递）
    NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.109:8082/api/v1/sendCode?email=%@", [self urlEncode:email]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 3. 发送 GET 请求
    [manager GET:url.absoluteString
      parameters:nil
        headers:nil
       progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 成功回调
            if (completion) {
                completion(responseObject, nil);
            }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 失败回调（包含网络错误和服务器返回的错误）
            if (completion) {
                completion(nil, error);
            }
        }];
}

// URL 编码工具方法
- (NSString *)urlEncode:(NSString *)string {
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

#pragma mark - 注册
- (void)registerWithNickname:(NSString *)nickname
                    password:(NSString *)password
                       email:(NSString *)email
                        code:(NSString *)code
                  completion:(CompletionHandler)completion {
    NSString *url = @"http://192.168.1.109:8082/api/v1/signup";
    NSDictionary *params = @{
        @"nickname": nickname,
        @"password": password,
        @"email": email,
        @"code": code
    };
    
    // 临时增加超时时间
    self.sessionManager.requestSerializer.timeoutInterval = 20.0;
    
    [self.sessionManager POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

#pragma mark - 登录
- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(CompletionHandler)completion {
    NSString *url = @"http://192.168.1.109:8082/api/v1/login";
    NSDictionary *params = @{
        @"email": email,
        @"password": password
    };
    
    [self.sessionManager POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

@end


//#pragma mark - 验证码
//- (void)sendVerificationCodeToEmail:(NSString *)email completion:(CompletionHandler)completion {
//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.39:8082/api/v1/sendCode"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    request.timeoutInterval = 15.0;
//    
//    NSDictionary *params = @{@"email": email};
//    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
//    
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            completion(nil, error);
//            return;
//        }
//        
//        NSError *jsonError;
//        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (jsonError) {
//                completion(nil, jsonError);
//            } else {
//                completion(responseDict, nil);
//            }
//        });
//    }];
//    
//    [task resume];
//}
//
//#pragma mark - 注册
//- (void)registerWithNickname:(NSString *)nickname
//                          ID:(NSString *)userID
//                    password:(NSString *)password
//                       email:(NSString *)email
//            verificationCode:(NSString *)code
//                  completion:(CompletionHandler)completion {
//    NSURL *url = [NSURL URLWithString:@"http://192.168.194.32:8082/api/v1/signup"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    request.timeoutInterval = 20.0;
//    
//    NSDictionary *params = @{
//        @"nickname": nickname,
//        @"user_id": userID,
//        @"password": password,
//        @"email": email,
//        @"verification_code": code
//    };
//    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            completion(nil, error);
//            return;
//        }
//        
//        NSError *jsonError;
//        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            completion(jsonError ? nil : responseDict, jsonError);
//        });
//    }];
//    [task resume];
//}
//
//#pragma mark - 登录
//- (void)loginWithEmail:(NSString *)email
//              password:(NSString *)password
//            completion:(CompletionHandler)completion {
//    NSURL *url = [NSURL URLWithString:@"http://192.168.194.32:8082/api/v1/login"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    request.timeoutInterval = 15.0;
//    
//    NSDictionary *params = @{
//        @"email": email,
//        @"password": password
//    };
//    
//    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            completion(nil, error);
//            return;
//        }
//        NSError *jsonError;
//        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            completion(jsonError ? nil : responseDict, jsonError);
//        });
//    }];
//    
//    [task resume];
//}
//
//@end
