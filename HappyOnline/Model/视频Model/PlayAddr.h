//
//  PlayAddr.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/4/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayAddr : NSObject
@property (nonatomic, copy) NSArray<NSString *> *url_list; // 存储多个 URL
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@end

NS_ASSUME_NONNULL_END
