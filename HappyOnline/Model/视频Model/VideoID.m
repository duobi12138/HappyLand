//
//  VideoID.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/27.
//

#import "VideoID.h"

@implementation VideoID

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"data" : [NSArray class]  // 因为data数组中的元素都是数字
    };
}

@end
