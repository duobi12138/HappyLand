//
//  Statistics.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/20.
//

#import "Statistics.h"

@implementation Statistics

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"digg_count": @"digg_count",
        @"comment_count": @"comment_count",
        @"share_count": @"share_count"
    };
}

@end
