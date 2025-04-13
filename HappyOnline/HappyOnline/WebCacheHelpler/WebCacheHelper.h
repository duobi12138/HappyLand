//
//  WebCacheHelper.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/4/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^WebCacheCompletionBlock)(NSData * _Nullable data);


NS_ASSUME_NONNULL_BEGIN

@interface WebCacheHelper : NSObject

+ (instancetype)sharedHelper;

- (void)queryDataFromCacheWithURL:(NSURL *)url completion:(WebCacheCompletionBlock)completion;
- (void)storeData:(NSData *)data forURL:(NSURL *)url;

// 添加视频缓存相关方法
- (void)queryVideoFromCacheWithURL:(NSURL *)url completion:(void(^)(NSURL * _Nullable cachedFileURL))completion;
- (void)storeVideoData:(NSData *)data forURL:(NSURL *)url;

// 添加缓存大小管理
- (NSUInteger)getDiskCacheSize;
- (void)cleanDiskCacheWithCompletion:(void(^)(void))completion;
- (void)cleanDiskCacheToSize:(NSUInteger)maxSize completion:(void(^)(void))completion;

// 预加载视频
- (void)preloadVideoWithURL:(NSURL *)url;


- (NSString *)cacheKeyForURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
