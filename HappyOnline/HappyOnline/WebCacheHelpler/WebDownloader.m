//
//  WebDownloader.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/4/8.
//

#import "WebDownloader.h"

@implementation WebDownloader

+ (instancetype)sharedDownloader {
    static WebDownloader *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WebDownloader alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.name = @"com.demo.webDownloader";
        _downloadQueue.maxConcurrentOperationCount = 6;
    }
    return self;
}

- (WebDownloadOperation *)downloadWithRequest:(NSURLRequest *)request progress:(WebDownloadProgressBlock)progress completion:(WebDownloadCompletionBlock)completion {
    WebDownloadOperation *operation = [[WebDownloadOperation alloc] initWithRequest:request progress:progress completion:completion];
    [self.downloadQueue addOperation:operation];
    return operation;
}

- (void)cancelAllDownloads {
    [self.downloadQueue cancelAllOperations];
}

@end
