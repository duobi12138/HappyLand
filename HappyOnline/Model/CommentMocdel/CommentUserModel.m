//
//  CommentUserModel.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/25.
//

#import "CommentUserModel.h"

@implementation CommentUserModel

+ (instancetype)userWithDict:(NSDictionary *)dict {
    CommentUserModel *model = [[CommentUserModel alloc] init];
    model.uid = dict[@"uid"] ?: @"";
    model.nickname = dict[@"nickname"] ?: @"";
    
    // 获取头像URL
    if (dict[@"avatar_thumb"] && [dict[@"avatar_thumb"][@"url_list"] isKindOfClass:[NSArray class]]) {
        NSArray *urlList = dict[@"avatar_thumb"][@"url_list"];
        if (urlList.count > 0) {
            model.avatarUrl = urlList[0];
        }
    }
    
    return model;
}

@end
