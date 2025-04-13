//
//  NSString+Regex.h
//  HappyOnline
//
//  Created by 多比 on 2025/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Regex)

- (BOOL)matchesRegex:(NSString *)regex;

@end

NS_ASSUME_NONNULL_END
