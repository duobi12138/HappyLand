//
//  CommentUserModel.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentUserModel : NSObject

@property (nonatomic, copy) NSString *uid;               // 用户ID
@property (nonatomic, copy) NSString *nickname;          // 昵称
@property (nonatomic, copy) NSString *avatarUrl;         // 头像URL

+ (instancetype)userWithDict:(NSDictionary *)dict;


@end

NS_ASSUME_NONNULL_END
