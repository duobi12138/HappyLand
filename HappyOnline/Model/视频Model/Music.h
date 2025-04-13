//
//  Music.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/20.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface Music : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *cover_url; // 只保留第一个封面URL


+ (NSDictionary *)modelCustomPropertyMapper;

@end
