//
//  NSString+Extension.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

- (CGSize)singleLineSizeWithText:(UIFont *)font;

- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font;

+ (NSString *)formatCount:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
