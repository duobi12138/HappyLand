//
//  WebCache.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebCache : NSObject

@property (nonatomic, strong) NSCache *memoryCache;
@property (nonatomic, copy) NSString *diskCachePath;

+ (instancetype)sharedCache;

//检查内存缓存
- (NSData *)dataFromMemoryCacheForKey:(NSString *)key;
//检查磁盘缓存
- (NSData *)dataFromDiskCacheForKey:(NSString *)key;
//检查缓存(先内存后磁盘)
- (NSData *)dataFromCacheForKey:(NSString *)key;

//储存到内存缓存
- (void)storeDataToMemoryCache:(NSData *)data forKey:(NSString *)key;
//储存到磁盘缓存
- (void)storeDataToDiskCache:(NSData *)data forKey:(NSString *)key;
//储存到二级缓存
- (void)storeData:(NSData *)data forKey:(NSString *)key;

// 清除内存缓存
- (void)clearMemoryCache;
// 清除磁盘缓存
- (void)clearDiskCache;
// 清除所有缓存
- (void)clearAllCache;

- (NSString *)filePathForKey:(NSString *)key;


//获取缓存文件路径
- (NSString *)cachePathForKey:(NSString *)key;

//获得md5签名
- (NSString *)md5String:(NSString *)string;

- (BOOL)diskCacheExistsForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
