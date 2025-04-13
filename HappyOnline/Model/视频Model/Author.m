//
//  Author.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/20.
//

#import "Author.h"

@implementation Author

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"uid": @"uid",
        @"sec_uid": @"sec_uid",
        @"nickname": @"nickname",
        @"avatar_url": @"avatar_168x168.url_list[0]" 
    };
}

- (NSString *)safeAvatarURL {
    if (self.avatar_url.length > 0) {
        return self.avatar_url;
    }
    return @"default_avatar_placeholder"; // 或返回nil看业务需求
}

@end
