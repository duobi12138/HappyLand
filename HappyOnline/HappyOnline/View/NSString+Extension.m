//
//  NSString+Extension.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/18.
//


#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CTFramesetter.h>
#import <CoreText/CTFont.h>
#import <CoreText/CTStringAttributes.h>


@implementation NSString (Extension)

//计算单行文本行高、支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围
- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font {
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof (CGFloat), &leading };
    
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, self.length);
    
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(DBL_MAX, DBL_MAX), nil);
    
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    return size;
}


//计算单行文本宽度和高度，返回值与UIFont.lineHeight一致，支持开头空格计算。包含emoji表情符的文本行高返回值有较大偏差。

- (CGSize)singleLineSizeWithText:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

+ (NSString *)formatCount:(NSInteger)count {
    if (count < 0) count = 0; // 防止负数
    
    if(count < 10000) {
        return [NSString stringWithFormat:@"%ld", (long)count];
    } else {
        CGFloat wValue = count / 10000.0f;
        // 处理类似1.0w的情况显示为1w
        if (wValue == floor(wValue)) {
            return [NSString stringWithFormat:@"%.0fw", wValue];
        } else {
            return [NSString stringWithFormat:@"%.1fw", wValue];
        }
    }
}

@end
