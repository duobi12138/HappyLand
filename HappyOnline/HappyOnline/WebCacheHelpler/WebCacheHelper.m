//
//  WebCacheHelper.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/4/8.
//

#import "WebCacheHelper.h"
#import "WebCache.h"
#import "WebDownloader.h"
#import "WebCombineOperation.h"

@implementation WebCacheHelper

//+ (instancetype)sharedHelper {
//    static WebCacheHelper *instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[WebCacheHelper alloc] init];
//    });
//    return instance;
//}

+ (instancetype)sharedHelper {
    static dispatch_once_t once;
    static WebCacheHelper *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSString *)cacheKeyForURL:(NSURL *)url {
    if (!url) return nil;
    return [[WebCache sharedCache] md5String:url.absoluteString];
}

//- (void)queryDataFromCacheWithURL:(NSURL *)url completion:(WebCacheCompletionBlock)completion {
//    if (!url || !completion) return;
//    
//    NSString *key = [self cacheKeyForURL:url];
//    NSLog(@"查询缓存: %@", key);
//
//    // 创建缓存查询Operation
//    NSOperation *cacheOperation = [NSBlockOperation blockOperationWithBlock:^{
//        NSData *data = [[WebCache sharedCache] dataFromCacheForKey:key];
//        if (data) {
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                completion(data);
//            }];
//            NSLog(@"Helper缓存命中: %@", key);  // 打印缓存命中信息
//        } else {
//            NSLog(@"Helper缓存未命中");
//        }
//    }];
//    
//    // 创建下载Operation
//    WebDownloadOperation *downloadOperation = [[WebDownloadOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url] progress:nil completion:^(NSData * _Nullable data, NSError * _Nullable error) {
//        if (data && !error) {
//            // 下载成功，缓存数据
//            [[WebCache sharedCache] storeData:data forKey:key];
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                completion(data);
//            }];
//        } else {
//            // 下载失败
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                completion(nil);
//            }];
//        }
//    }];
//    
//    // 创建组合Operation
//    WebCombineOperation *combineOperation = [[WebCombineOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]
//                                                                       cacheOperation:cacheOperation
//                                                                   downloadOperation:downloadOperation];
//    
//    // 添加到下载队列
//    [[WebDownloader sharedDownloader].downloadQueue addOperation:combineOperation];
//}

//可以使用
//- (void)queryDataFromCacheWithURL:(NSURL *)url completion:(WebCacheCompletionBlock)completion {
//    if (!url || !completion) return;
//
//    NSString *key = [self cacheKeyForURL:url];
//    NSLog(@"查询缓存: %@", key);
//
//    // 创建缓存查询Operation
//    NSOperation *cacheOperation = [NSBlockOperation blockOperationWithBlock:^{
//        NSData *data = [[WebCache sharedCache] dataFromDiskCacheForKey:key];
//        if (data) {
//            NSLog(@"Helper缓存命中: %@", key);
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                completion(data);
//            }];
//        } else {
//            NSLog(@"Helper缓存未命中");
//            // 继续下载操作
//            [self downloadDataWithURL:url completion:completion];
//        }
//    }];
//
//    [[WebDownloader sharedDownloader].downloadQueue addOperation:cacheOperation];
//}

- (void)queryDataFromCacheWithURL:(NSURL *)url completion:(WebCacheCompletionBlock)completion {
    if (!url || !completion) return;

    NSString *key = [self cacheKeyForURL:url];
    NSLog(@"查询缓存: %@", key);

    // 创建缓存查询Operation
    NSOperation *cacheOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSData *data = [[WebCache sharedCache] dataFromDiskCacheForKey:key];
        if (data) {
            NSLog(@"Helper磁盘缓存命中: %@", key);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completion(data);
            }];
            return; // 找到磁盘缓存后直接返回
        }

        // 如果未命中，继续查询内存缓存
        data = [[WebCache sharedCache] dataFromCacheForKey:key];
        if (data) {
            NSLog(@"Helper内存缓存命中: %@", key);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completion(data);
            }];
            return; // 找到内存缓存后直接返回
        }

        NSLog(@"Helper缓存未命中");
        [self downloadDataWithURL:url completion:completion];
    }];

    [[WebDownloader sharedDownloader].downloadQueue addOperation:cacheOperation];
}

//随上面添加
- (void)downloadDataWithURL:(NSURL *)url completion:(WebCacheCompletionBlock)completion {
    WebDownloadOperation *downloadOperation = [[WebDownloadOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url] progress:nil completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (data && !error) {
            [[WebCache sharedCache] storeData:data forKey:[self cacheKeyForURL:url]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completion(data);
            }];
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completion(nil);
            }];
        }
    }];
    NSLog(@"下载Data");
    [[WebDownloader sharedDownloader].downloadQueue addOperation:downloadOperation];
}

- (void)storeData:(NSData *)data forURL:(NSURL *)url {
    if (!data || !url) return;
    
    NSString *key = [self cacheKeyForURL:url];
    [[WebCache sharedCache] storeData:data forKey:key];
}

//更新
- (void)queryVideoFromCacheWithURL:(NSURL *)url completion:(void (^)(NSURL * _Nullable))completion {
    NSString *key = [self cacheKeyForURL:url];
    NSData *data = [[WebCache sharedCache] dataFromCacheForKey:key];
    
    if (data) {
        // 将数据写入临时文件
        NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", key]];
        if ([data writeToFile:tempPath atomically:YES]) {
            completion([NSURL fileURLWithPath:tempPath]);
            return;
        }
    }
    
    completion(nil);
}



- (void)storeVideoData:(NSData *)data forURL:(NSURL *)url {
    if (data.length > 100 * 1024 * 1024) { // 大于100MB的视频不缓存
        return;
    }
    
    NSString *key = [self cacheKeyForURL:url];
    [[WebCache sharedCache] storeData:data forKey:key];
}

- (NSUInteger)getDiskCacheSize {
    NSString *cachePath = [[WebCache sharedCache] diskCachePath];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:cachePath];
    NSUInteger totalSize = 0;
    
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        totalSize += [attrs fileSize];
    }
    
    return totalSize;
}

- (void)cleanDiskCacheWithCompletion:(void (^)(void))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachePath = [[WebCache sharedCache] diskCachePath];
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:nil];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), completion);
        }
    });
}

- (void)cleanDiskCacheToSize:(NSUInteger)maxSize completion:(void (^)(void))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachePath = [[WebCache sharedCache] diskCachePath];
        NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:cachePath];
        
        // 获取所有文件及其属性
        NSMutableArray *files = [NSMutableArray array];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            if (attrs) {
                [files addObject:@{@"path": filePath, @"date": [attrs fileModificationDate], @"size": @([attrs fileSize])}];
            }
        }
        
        // 按修改时间排序（最旧的排前面）
        NSArray *sortedFiles = [files sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *file1, NSDictionary *file2) {
            return [file1[@"date"] compare:file2[@"date"]];
        }];
        
        // 计算当前总大小
        NSUInteger currentSize = [[files valueForKeyPath:@"@sum.size"] unsignedIntegerValue];
        
        // 删除最旧的文件直到满足大小限制
        for (NSDictionary *file in sortedFiles) {
            if (currentSize <= maxSize) {
                break;
            }
            
            [[NSFileManager defaultManager] removeItemAtPath:file[@"path"] error:nil];
            currentSize -= [file[@"size"] unsignedIntegerValue];
        }
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), completion);
        }
    });
}

- (void)preloadVideoWithURL:(NSURL *)url {
    NSString *key = [self cacheKeyForURL:url];
    
    // 检查是否已缓存
    if ([[WebCache sharedCache] diskCacheExistsForKey:key]) {
        return;
    }
    
    // 使用NSURLSession下载视频但不播放
    NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (location && !error) {
            NSData *videoData = [NSData dataWithContentsOfURL:location];
            if (videoData) {
                [self storeVideoData:videoData forURL:url];
            }
        }
    }];
    
    [downloadTask resume];
}

@end
