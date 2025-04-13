//
//  Manger.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/25.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>
#import "Aweme.h"
#import "VideoID.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^successBlockAweme)(Aweme *aweme);
typedef void(^successBlockVideoId)(NSArray *videoIDArray);
typedef void(^myError)(NSError* error);

@interface Manger : NSObject

+ (instancetype)sharedSingleton;


- (void)netWorkWithAweme:(successBlockAweme)success
                andError:(myError)failure andVideoID:(NSString *)VideoID;

-(void)netWorkWithVideoId:(successBlockVideoId)success andError:(myError)failure andCurrentIndex:(NSInteger) currentIndex;

@end

NS_ASSUME_NONNULL_END
