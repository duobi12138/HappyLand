//
//  UserManager.m
//  HappyOnline
//
//  Created by 多比 on 2025/3/26.
//

#import "UserManager.h"

@interface UserManager ()

@property (nonatomic, strong) NSMutableDictionary *usersDict;

@end

@implementation UserManager

+ (instancetype)shared {
    static UserManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserManager alloc] init];
        instance.usersDict = [NSMutableDictionary dictionary];
    });
    return instance;
}

- (void)addUser:(User *)user {
    [self.usersDict setObject:user forKey:user.account];
}

- (User *)getUserByAccount:(NSString *)account {
    return [self.usersDict objectForKey:account];
}

@end
