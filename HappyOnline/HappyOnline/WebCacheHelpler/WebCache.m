//
//  WebCache.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/4/8.
//

#import "WebCache.h"
#import <CommonCrypto/CommonDigest.h>//需学习

@implementation WebCache

+ (instancetype)sharedCache {
    static WebCache *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WebCache alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init] ) {
        _memoryCache = [[NSCache alloc] init];
        _memoryCache.name = @"com.demo.webCache";
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskCachePath = [paths[0] stringByAppendingPathComponent:@"com.demo.webCache"];
        
        //创建磁盘缓存目录
        if (![[NSFileManager defaultManager] fileExistsAtPath:_diskCachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}


//检查
- (NSData *)dataFromMemoryCacheForKey:(NSString *)key {
    return [self.memoryCache objectForKey:key];
}

- (NSData *)dataFromDiskCacheForKey:(NSString *)key {
    NSString *filePath = [self cachePathForKey:key];
    return [NSData dataWithContentsOfFile:filePath];
}

- (NSData *)dataFromCacheForKey:(NSString *)key {
    NSData *data = [self dataFromMemoryCacheForKey:key];
    if (data) {
        return data;
    }
    return [self dataFromDiskCacheForKey:key];
}

//储存
- (void)storeDataToMemoryCache:(NSData *)data forKey:(NSString *)key {
    if (data && key) {
        [self.memoryCache setObject:data forKey:key];
    }
}

//- (void)storeDataToDiskCache:(NSData *)data forKey:(NSString *)key {
//    if (data && key) {
//        NSString *filePath = [self cachePathForKey:key];
//        [data writeToFile:filePath atomically:YES];
//    }
//}

// 修改存储方法，支持大文件异步存储
- (void)storeDataToDiskCache:(NSData *)data forKey:(NSString *)key {
    if (data.length > 5 * 1024 * 1024) { // 大于5MB的文件异步存储
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *filePath = [self cachePathForKey:key];
            [data writeToFile:filePath atomically:YES];
        });
    } else {
        NSString *filePath = [self cachePathForKey:key];
        [data writeToFile:filePath atomically:YES];
    }
}

- (void)storeData:(NSData *)data forKey:(NSString *)key {
    [self storeDataToMemoryCache:data forKey:key];
    [self storeDataToDiskCache:data forKey:key];
}

//清除
- (void)clearMemoryCache {
    [self.memoryCache removeAllObjects];
}

- (void)clearDiskCache {
    [[NSFileManager defaultManager] removeItemAtPath:self.diskCachePath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:self.diskCachePath
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:nil];
}

- (void)clearAllCache {
    [self clearMemoryCache];
    [self clearDiskCache];
}

//获取文件路径
- (NSString *)cachePathForKey:(NSString *)key {
    NSString *filename = [self md5String:key];
    return [self.diskCachePath stringByAppendingPathComponent:filename];
}

- (NSString *)md5String:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

// 添加方法：获取文件路径而不加载到内存
- (NSString *)filePathForKey:(NSString *)key {
    return [self cachePathForKey:key];
}

// 添加方法：检查文件是否存在
- (BOOL)diskCacheExistsForKey:(NSString *)key {
    NSString *filePath = [self cachePathForKey:key];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

@end
