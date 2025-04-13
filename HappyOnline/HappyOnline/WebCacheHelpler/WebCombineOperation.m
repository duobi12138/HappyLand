//
//  WebCombineOperation.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/4/8.
//

#import "WebCombineOperation.h"

@interface WebCombineOperation ()

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

@end

@implementation WebCombineOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithRequest:(NSURLRequest *)request cacheOperation:(NSOperation *)cacheOperation downloadOperation:(WebDownloadOperation *)downloadOperation {
    if (self = [super init]) {
        _request = request;
        _cacheOperation = cacheOperation;
        _downloadOperation = downloadOperation;
    }
    return self;
}

- (void)start {
    if (self.isCancelled) {
        self.finished = YES;
        return;
    }
    
    self.executing = YES;
    
    __weak __typeof(self) weakSelf = self;
    if (self.cacheOperation) {
        [self.cacheOperation setCompletionBlock:^{
            if (weakSelf.isCancelled) {
                [weakSelf finish];
                return;
            }
            
            if (weakSelf.downloadOperation) {
                [weakSelf.downloadOperation start];
            } else {
                [weakSelf finish];
            }
        }];
        [self.cacheOperation start];
    } else if (self.downloadOperation) {
        [self.downloadOperation start];
    } else {
        [self finish];
    }
}
- (void)cancel {
    if (self.isFinished) return;
    
    [super cancel];
    
    if (self.cacheOperation) {
        [self.cacheOperation cancel];
    }
    
    if (self.downloadOperation) {
        [self.downloadOperation cancel];
    }
    
    [self finish];
}

- (void)finish {
    self.executing = NO;
    self.finished = YES;
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}


-(void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isConcurrent {
    return YES;
}

@end
