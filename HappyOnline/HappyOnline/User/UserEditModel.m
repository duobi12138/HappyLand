//
//  UserEditModel.m
//  HappyOnline
//
//  Created by 多比 on 2025/4/10.
//

#import "UserEditModel.h"

@implementation AvatarURLs
// YYModel 自动映射字段
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"url_list" : @"url_list",
        @"height" : @"height",
        @"width" : @"width"
    };
}
@end

@implementation UserEditModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"uid" : @"uid",
        @"sec_uid" : @"sec_uid",
        @"nickname" : @"nickname",
        @"signature" : @"signature",
        @"follower_count" : @"follower_count",
        @"following_count" : @"following_count",
        @"aweme_count" : @"aweme_count",
        @"favoriting_count" : @"favoriting_count",
        @"avatar_larger" : @"avatar_larger",
        @"ip_location" : @"ip_location"
    };
}

// 嵌套模型指定
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"avatar_larger" : [AvatarURLs class]
    };
}

@end
