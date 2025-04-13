//
//  WebDownloadOperation.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/4/8.
//

#import <Foundation/Foundation.h>

typedef void(^WebDownloadProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef void(^WebDownloadCompletionBlock)(NSData * _Nullable data, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface WebDownloadOperation : NSOperation


- (instancetype)initWithRequest:(nonnull NSURLRequest *)request
                      progress:(nullable WebDownloadProgressBlock)progress
                    completion:(nullable WebDownloadCompletionBlock)completion;

@property (nonatomic, strong, readonly) NSURLRequest *request;

@end

NS_ASSUME_NONNULL_END
