//
//  VideoPlayInfo.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/25.
//

#import "Video.h"

@implementation Video
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"play_addr": @"play_addr",
        @"width": @"width",
        @"height": @"height"
    };
}

// 提供一个便捷方法获取第一个播放 URL
- (NSString *)play_url {
    return self.play_addr.url_list.firstObject;
}
@end
