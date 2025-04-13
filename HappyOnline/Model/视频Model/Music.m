//
//  Music.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/20.
//

#import "Music.h"

@implementation Music
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"title": @"title",
        @"author": @"author",
        @"cover_url": @"cover_large.url_list[0]"
    };
}

@end
