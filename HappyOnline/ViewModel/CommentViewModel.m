//
//  CommentViewModel.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/25.
//

#import "CommentViewModel.h"
#import "Manger.h"
#import <AFNetworking/AFNetworking.h>

@implementation CommentViewModel
-(instancetype)init {
    self = [super init];
    if(self) {
        _comments = @[];
        _cursor = 0;
        _hasMore = YES;
    }
    return self;
}


- (void)loadCommentsWithSuccess:(nonnull CommentRequestSuccess)success failure:(nonnull CommentRequestFailure)failure {
    self.cursor = 0;
    [self fetchCommentsWithSuccess:success failuer:failure];

}

- (void)loadMoreCommentsWithSuccess:(nonnull CommentRequestSuccess)success failure:(nonnull CommentRequestFailure)failure {
    if (!self.hasMore) {
        if (success) {
            success(self.comments, NO);
        }
        return;
    }
    [self fetchCommentsWithSuccess:success failuer:failure];

    
}

- (void)fetchCommentsWithSuccess:(CommentRequestSuccess) success failuer:(CommentRequestFailure) failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.0;
    
    //设置请求头，原URL
    //[manager.requestSerializer setValue:@"Mozilla/5.0" forHTTPHeaderField:@"User-Agent"];
    NSString *token = @"4uA3VWVs4iIk7RwFymTgol0I+AU9jZHWrp4i5Ay4q2dg13MOZvNj4wOzVw==";
    //NSString *token = @"1JE3G3ovxFsQsQoE9Hartno0/S4IkLnHjZ9Jygm3sT1RwmUqS6Ui1C2aAA==";

    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token]
                    forHTTPHeaderField:@"Authorization"];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.tikhub.io/api/v1/douyin/app/v3/fetch_video_comments?aweme_id=%@&cursor=%ld&count=20",self.awemeId,(long)self.cursor];
    
    //新URL
    
//    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.39:8082/api/v1/fetch_video_comments?aweme_id=%@&cursor=%ld&count=20",self.awemeId,(long)self.cursor];
    
    NSLog(@"commentURL:%@",urlStr);

    [manager GET:urlStr parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            NSInteger code = [responseDict[@"code"] integerValue];
            
            if (code == 200) {
                
                NSArray *commentDicts = responseDict[@"data"][@"comments"];
                NSMutableArray *newComments = [NSMutableArray array];
                
                for (NSDictionary *dict in commentDicts) {
                    CommentModel *model = [CommentModel commentWithDict:dict];
                    [newComments addObject:model];
                }
                
                if (self.cursor == 0) {
                    self.comments = newComments;
                } else {
                    self.comments = [self.comments arrayByAddingObjectsFromArray:newComments];
                }
                
                self.cursor = [responseDict[@"data"][@"cursor"] integerValue];
                self.hasMore = [responseDict[@"data"][@"has_more"] boolValue];
                
                if (success) {
                    success(self.comments, self.hasMore);
                                     }
                
            } else {
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
}

@end
