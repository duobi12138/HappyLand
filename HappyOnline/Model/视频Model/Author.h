//
//  Author.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/20.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface Author : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *sec_uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar_url; 

+ (NSDictionary *)modelCustomPropertyMapper;
- (NSString *)safeAvatarURL;

@end
