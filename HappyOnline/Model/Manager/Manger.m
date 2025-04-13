//
//  Manger.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/25.
//

#import "Manger.h"

@implementation Manger

static Manger *mangerSington = nil;

+ (instancetype)sharedSingleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mangerSington = [[super allocWithZone:NULL] init];
    });
    return mangerSington;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [Manger sharedSingleton];
}

- (id)copyWithZone:(NSZone *)zone {
    return [Manger sharedSingleton];
}

- (void)netWorkWithAweme:(successBlockAweme)success
                andError:(myError)failure andVideoID:(nonnull NSString *)VideoID{
    
    // 1. 创建会话管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.0;
    
    //2. 设置请求头（AFNetworking 3.x 方式）
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    // 修改请求头设置（增加Bearer前缀）
    //NSString *token = @"2vkUU0da1GQ4ggA5/TThwmst6D8V2YDJta19zm3+rm9x/HgxLKQ2nR2FAA==";
//    NSString *token = @"mJNubn14n3Fw53Ac0Tm/i0Uu1CUTlJnm7o9y7TTK70Ja8FwPVuVqwAC8Xw==";
//
//    
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token]
//                    forHTTPHeaderField:@"Authorization"];
//    
//    NSDictionary *headers = manager.requestSerializer.HTTPRequestHeaders;
    //NSLog(@"当前请求头: %@", headers);
//    
//    // 3. 构建请求URL和参数
    //原URL：
    //NSString *urlStr = [NSString stringWithFormat:@"https://api.tikhub.io/api/v1/douyin/app/v3/fetch_one_video?aweme_id=%@",VideoID];
    
    //后端URL
      NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.109:8082/api/v1/videoID/%@",VideoID];
    
    
    //NSLog(@"urL:%@",urlStr);
//    NSDictionary *params = @{
//        @"aweme_id": awemeId ?: @"",
//        @"region": @"CN",
//        @"device_platform": @"iphone"
//    };
//    NSLog(@"最终请求URL: %@", request.URL.absoluteString);

    
    
    
    // 4. 发送GET请求（3.x版本不带headers参数）
    [manager GET:urlStr
      parameters:nil
         headers:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             // 5. 成功回调处理
             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                 NSDictionary *responseDict = (NSDictionary *)responseObject;
                 NSInteger code = [responseDict[@"code"] integerValue];
                 
                 if (code == 200) {
                     Aweme *aweme = [Aweme yy_modelWithJSON:responseDict[@"data"][@"aweme_detail"]];

                     
                     if (responseDict[@"data"][@"aweme_detail"][@"author"][@"avatar_168x168"][@"url_list"][0]) {
                         aweme.author.avatar_url = responseDict[@"data"][@"aweme_detail"][@"author"][@"avatar_168x168"][@"url_list"][0];
                     }

//
//                     NSArray *downloadURLs = responseDict[@"data"][@"aweme_detail"][@"video"][@"play_addr"][@"url_list"];
//                     if (downloadURLs.count > 0) {
//                         NSString *videoDownloadURL = downloadURLs[0]; // 取第一个 URL
//                         NSLog(@"视频下载 URL: %@", videoDownloadURL);
//                     }
                     
                     // 确保sec_uid有值
                     if (!aweme.author.sec_uid) {
                         aweme.author.sec_uid = responseDict[@"data"][@"aweme_detail"][@"author"][@"sec_uid"] ?: @"";
                     }
                     
                     if (success) success(aweme);
                 } else {
                     // 业务错误
                     NSError *bizError = [NSError errorWithDomain:@"DouYinAPIErrorDomain"
                                                             code:code
                                                         userInfo:@{
                             NSLocalizedDescriptionKey: @"抖音API返回错误",
                             @"response": responseDict ?: @{}
                         }];
                     if (failure) failure(bizError);
                 }
             } else {
                 // 数据格式错误
                 NSError *formatError = [NSError errorWithDomain:@"DataFormatErrorDomain"
                                                            code:-1
                                                        userInfo:@{
                     NSLocalizedDescriptionKey: @"返回数据格式不正确"
                 }];
                 if (failure) failure(formatError);
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"NetWorkError:%@",error);
             // 6. 失败回调
             if (failure) failure(error);
         }];
}

-(void)netWorkWithVideoId:(successBlockVideoId)success andError:(myError)failure andCurrentIndex:(NSInteger)currentIndex
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    currentIndex++;
    
    NSString *str = [NSString stringWithFormat:@"http://192.168.1.109:8082/api/v1/getVideo/%ld/2",(long)currentIndex];
    NSLog(@"commentURL:%@",str);
    [manager GET:str parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *videoIDs = responseObject[@"data"]; // 直接获取数组
            NSLog(@"视频ID数组: %@", videoIDs);
            success(videoIDs); // 回调数组
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
}

@end
