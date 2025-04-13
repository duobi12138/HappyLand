//
//  Aweme.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/20.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "Author.h"
#import "Music.h"
#import "YYModel.h"
#import "Statistics.h"
#import "Video.h"

@class Author, Music, Statistics;

@interface Aweme : NSObject

@property (nonatomic, copy) NSString *aweme_id;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) Author *author;
@property (nonatomic, strong) Music *music;
@property (nonatomic, strong) Statistics *statistics;
@property (nonatomic, strong) Video *video;

+ (NSDictionary *)modelContainerPropertyGenericClass;

- (NSString *)safeVideoURL;


@end
