//
//  UserEditModel.h
//  HappyOnline
//
//  Created by 多比 on 2025/4/10.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
#import "YYModel/YYModel.h"

NS_ASSUME_NONNULL_BEGIN

// 用户头像信息（多尺寸）
@interface AvatarURLs : NSObject
@property (nonatomic, copy) NSArray<NSString *> *url_list; // 头像URL数组
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger width;
@end

@interface UserEditModel : NSObject
@property (nonatomic, copy) NSString *uid;                // 用户ID "1673937488185292"
@property (nonatomic, copy) NSString *sec_uid;           // 加密ID "MS4wLjABAAA..."
@property (nonatomic, copy) NSString *nickname;         // 昵称 "中华小涵崽"
@property (nonatomic, copy) NSString *signature;        // 个性签名 "接永劫陪🥣..."
@property (nonatomic, assign) NSInteger follower_count; // 粉丝数 27656
@property (nonatomic, assign) NSInteger following_count;// 关注数 202
@property (nonatomic, assign) NSInteger aweme_count;   // 作品数 96
@property (nonatomic, assign) NSInteger favoriting_count; // 喜欢数 879
@property (nonatomic, strong) AvatarURLs *avatar_larger; // 大头像（1080x1080）
@property (nonatomic, copy) NSString *ip_location;      // IP属地 "IP属地：浙江"

// YYModel 解析方法
+ (instancetype)yy_modelWithJSON:(id)json;

@end

NS_ASSUME_NONNULL_END
