//
//  UserManager.h
//  HappyOnline
//
//  Created by 多比 on 2025/3/26.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject

+ (instancetype)shared;

- (void)addUser:(User *)user;

- (User *)getUserByAccount:(NSString *)account;

@end

NS_ASSUME_NONNULL_END
