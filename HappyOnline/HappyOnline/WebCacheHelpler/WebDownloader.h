//
//  WebDownloader.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/4/8.
//

#import <Foundation/Foundation.h>
#import "WebDownloadOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebDownloader : NSObject

@property (nonatomic, strong) NSOperationQueue *downloadQueue;

+ (instancetype)sharedDownloader;

- (WebDownloadOperation *)downloadWithRequest:(NSURLRequest *)request
                                    progress:(WebDownloadProgressBlock)progress
                                  completion:(WebDownloadCompletionBlock)completion;

- (void)cancelAllDownloads;

@end

NS_ASSUME_NONNULL_END
