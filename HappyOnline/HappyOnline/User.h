//
//  User.h
//  HappyOnline
//
//  Created by 多比 on 2025/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;

@end

NS_ASSUME_NONNULL_END
