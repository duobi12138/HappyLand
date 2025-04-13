//
//  Aweme.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/20.
//

#import "Aweme.h"

@implementation Aweme

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"author" : [Author class],
        @"music" : [Music class],
        @"statistics" : [Statistics class],
        @"video" : [Video class]
    };
}

- (NSString *)safeVideoURL {
    if (self.video.play_addr.url_list[0].length > 0) {
        return self.video.play_addr.url_list[0];
    }
    NSLog(@"视频URL为空，aweme_id: %@", self.aweme_id);
    return nil;
}

@end
