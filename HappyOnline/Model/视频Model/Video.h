//
//  VideoPlayInfo.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/25.
//

#import <Foundation/Foundation.h>
#import "PlayAddr.h"

NS_ASSUME_NONNULL_BEGIN

@interface Video : NSObject
@property (nonatomic, strong) PlayAddr *play_addr; // 映射 play_addr.url_list[0]
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;

+ (NSDictionary *)modelCustomPropertyMapper;


@end

NS_ASSUME_NONNULL_END
