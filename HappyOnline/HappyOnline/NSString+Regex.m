//
//  NSString+Regex.m
//  HappyOnline
//
//  Created by 多比 on 2025/4/8.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

- (BOOL)matchesRegex:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

@end
