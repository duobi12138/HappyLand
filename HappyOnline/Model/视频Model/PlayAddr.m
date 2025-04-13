//
//  PlayAddr.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/4/3.
//

#import "PlayAddr.h"
#import "YYModel.h"
@implementation PlayAddr
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"url_list": @"url_list",
        @"width": @"width",
        @"height": @"height"
    };
}
@end
