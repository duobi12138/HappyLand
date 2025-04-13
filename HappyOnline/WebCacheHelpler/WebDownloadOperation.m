//
//  WebDownloadOperation.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/4/8.
//

#import "WebDownloadOperation.h"

@interface WebDownloadOperation () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, copy) WebDownloadProgressBlock progressBlock;
@property (nonatomic, copy) WebDownloadCompletionBlock downloadCompletionBlock;

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, assign) NSInteger expectedSize;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

@end

@implementation WebDownloadOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithRequest:(NSURLRequest *)request
                      progress:(WebDownloadProgressBlock)progress
                    completion:(WebDownloadCompletionBlock)completion {
    if (self = [super init]) {
        _request = request;
        _progressBlock = progress ? [progress copy] : nil;
        _downloadCompletionBlock = completion ? [completion copy] : nil;
    }
    return self;
}

- (void)start {
    @synchronized (self) {
        if (self.isCancelled) {
            self.finished = YES;
            return;
        }
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 15;
        
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        self.dataTask = [self.session dataTaskWithRequest:self.request];
        self.executing = YES;
        [self.dataTask resume];
    }
}

- (void)cancel {
    @synchronized (self) {
        if (self.isFinished) return;
        
        [super cancel];
        
        if (self.dataTask) {
            [self.dataTask cancel];
            if (self.isExecuting) self.executing = NO;
            if (!self.isFinished) self.finished = YES;
        }
        
        [self reset];
    }
}

- (void)reset {
    self.dataTask = nil;
    self.data = nil;
    self.session = nil;
}

-(void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isConcurrent {
    return YES;
}


#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    if (self.isCancelled) {
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode == 200) {
        self.data = [NSMutableData data];
        self.expectedSize = response.expectedContentLength;
        completionHandler(NSURLSessionResponseAllow);
    } else {
        completionHandler(NSURLSessionResponseCancel);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (self.isCancelled) return;
    
    [self.data appendData:data];
    if (self.progressBlock) { // 检查是否为nil
        self.progressBlock(self.data.length, self.expectedSize);
    }
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    @synchronized (self) {
        if (self.isCancelled) return;
        
        if (self.downloadCompletionBlock) { // 使用新属性名
            self.downloadCompletionBlock(self.data, error);
        }
        
        [self reset];
        self.executing = NO;
        
        self.finished = YES;
    }
}

@end
