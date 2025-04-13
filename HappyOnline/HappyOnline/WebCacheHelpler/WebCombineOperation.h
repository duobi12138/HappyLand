//
//  WebCombineOperation.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/4/8.
//

#import <Foundation/Foundation.h>
#import "WebDownloadOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebCombineOperation : NSOperation

@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, strong, readonly) NSOperation *cacheOperation;
@property (nonatomic, strong, readonly) WebDownloadOperation *downloadOperation;


- (instancetype)initWithRequest:(NSURLRequest *)request
               cacheOperation:(NSOperation *)cacheOperation
           downloadOperation:(WebDownloadOperation *)downloadOperation;

- (void)cancel;


@end

NS_ASSUME_NONNULL_END
